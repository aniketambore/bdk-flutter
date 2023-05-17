import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/foundation.dart';

class Bdk {
  final List<Wallet> _wallets = [];
  late Blockchain _blockchain;

  static const mnemonicList = [
    "tail refuse rally credit exhaust blind surprise cat report flock foster normal",
    "click hospital smooth pave message country maximum state pitch route excess virus",
    "breeze street razor right post shell access firm this ship love spin",
  ];

  Future<String> _generateMnemonic(int walletIndex) async {
    // final mnemonic = await Mnemonic.create(WordCount.Words12);
    // return mnemonic.asString();
    return mnemonicList[walletIndex];
  }

  Future<List<Descriptor>> _getDescriptors(String mnemonic) async {
    final descriptors = <Descriptor>[];
    for (var e in [KeychainKind.External, KeychainKind.Internal]) {
      final mnemonicObj = await Mnemonic.fromString(mnemonic);
      final descriptorSecretKey = await DescriptorSecretKey.create(
        network: Network.Testnet,
        mnemonic: mnemonicObj,
      );
      final descriptor = await Descriptor.newBip84(
        secretKey: descriptorSecretKey,
        network: Network.Testnet,
        keychain: e,
      );
      descriptors.add(descriptor);
    }
    return descriptors;
  }

  Future<Blockchain> _blockchainInit() async {
    final blockchain = await Blockchain.create(
      config: const BlockchainConfig.electrum(
        config: ElectrumConfig(
          stopGap: 10,
          timeout: 5,
          retry: 5,
          url: "ssl://electrum.blockstream.info:60002",
          validateDomain: false,
        ),
      ),
    );
    return blockchain;
  }

  Future<Wallet> _initWallet(
    List<Descriptor> descriptors,
    Network network,
  ) async {
    final wallet = await Wallet.create(
      descriptor: descriptors[0],
      changeDescriptor: descriptors[1],
      network: network,
      databaseConfig: const DatabaseConfig.memory(),
    );
    return wallet;
  }

  Future<void> createWallets({
    Network? network,
    String? recoveryMnemonic,
  }) async {
    debugPrint('[+] Running: [bdk.dart | createWallet]');
    for (int i = 0; i < 3; i++) {
      final mnemonic = recoveryMnemonic ?? await _generateMnemonic(i);
      final descriptors = await _getDescriptors(mnemonic);
      _blockchain = await _blockchainInit();
      final wallet = await _initWallet(descriptors, network ?? Network.Testnet);
      _wallets.add(wallet);
      debugPrint('[+] $i Success: [bdk.dart | createWallet]');
      debugPrint('[+] $i Mnemonic: [bdk.dart | $mnemonic]');
    }
  }

  Future<String> getAddress(int walletIndex) async {
    debugPrint('[+] Running: [bdk.dart | getAddress]');
    final addressInfo = await _wallets[walletIndex]
        .getAddress(addressIndex: const AddressIndex());
    debugPrint('[+] Wallet: $walletIndex, Address: ${addressInfo.address}');
    return addressInfo.address;
  }

  Future<int> getBalance(int walletIndex) async {
    debugPrint('[+] Running: [bdk.dart | getBalance]');
    try {
      _wallets[walletIndex].sync(_blockchain);
      final balance = await _wallets[walletIndex].getBalance();
      return balance.total;
    } catch (e) {
      debugPrint('[!] Error: [bdk.dart | syncWallet]: $e');
      throw Exception();
    }
  }
}
