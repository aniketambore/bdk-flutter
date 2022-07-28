import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bdk_flutter/bdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late BdkWallet bdkWallet = BdkWallet(
      descriptor: "wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/0/*)",
      changeDescriptor:"wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/1/*)",
      network: Network.TESTNET);

  @override
  void initState() {
    restoreWallet("puppy interest whip tonight dad never sudden response push zone pig patch", Network.TESTNET);
    super.initState();
  }






  BdkWallet createOrRestoreWallet(String descriptor, String changeDescriptor, Network network)  {
    bdkWallet = BdkWallet(descriptor: descriptor, changeDescriptor: changeDescriptor, network: network);
    bdkWallet.sync();
    return bdkWallet;
  }
  restoreWallet(String mnemonic, Network network) async {
    var  key = await restoreExtendedKey(network, mnemonic);
    var descriptor = createDescriptor(key.xprv);
    var changeDescriptor = createChangeDescriptor(key.xprv);
    createOrRestoreWallet(descriptor, changeDescriptor, network);
    bdkWallet.sync();
    return bdkWallet;
  }

  sync() async {
  }

  getNewAddress() async {
    await bdkWallet.getNewAddress().then((value) => print(value));
  }

  getConfirmedTransactions() async {
    final res =  await bdkWallet.getConfirmedTransactions();
    for (var e in res) {
      print(e.details.txid);
    }
  }

  getPendingTransactions() async {
    final res =  await bdkWallet.getPendingTransactions();
    res.map((e) => print(e.details.txid));
  }
  getBalance() async {
    final res =  await bdkWallet.getBalance();
    print(res.toString());
  }

  resetWallet() async {
    // await _bdkFlutterPlugin.resetWallet().then((i) {
    //   print(i);
    // });
  }

  sendBit() async {
    //  https://testnet-faucet.mempool.co/ address
    await bdkWallet.createTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bdkWallet.network.name),
              TextButton(
                  onPressed: () => getNewAddress(),
                  child: const Text('Press to create new Address')),
              TextButton(
                  onPressed: () => sendBit(),
                  child: const Text('Press to  send 1200 satoshi')),
              TextButton(
                  onPressed: () => sync(), child: const Text('Press to  sync')),
              TextButton(
                  onPressed: () => getConfirmedTransactions(),
                  child: const Text('Get ConfirmedTransactions')),
              TextButton(
                  onPressed: () => getPendingTransactions(),
                  child: const Text('getPendingTransactions')),
              TextButton(
                  onPressed: () =>  getBalance(),
                  child: const Text('get Balance')),
            ],
          ),
        ),
      ),
    );
  }
}
