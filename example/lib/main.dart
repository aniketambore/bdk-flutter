import 'package:flutter/material.dart';
import 'bdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _bdkApi = Bdk();

  String output = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SelectableText('OUTPUT: $output'),
                ElevatedButton(
                  onPressed: () => _bdkApi.createWallets(),
                  child: const Text('Create 3 Wallets'),
                ),
                getAddressButton(0),
                getBalanceButton(0),
                getAddressButton(1),
                getBalanceButton(1),
                getAddressButton(2),
                getBalanceButton(2),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget getAddressButton(int walletIndex) {
    return ElevatedButton(
      onPressed: () async {
        final address = await _bdkApi.getAddress(walletIndex);
        setState(() {
          output = "Wallet: $walletIndex \nAddress: $address";
        });
      },
      child: Text('Get Address $walletIndex'),
    );
  }

  Widget getBalanceButton(int walletIndex) {
    return ElevatedButton(
      onPressed: () async {
        final balance = await _bdkApi.getBalance(walletIndex);
        setState(() {
          output = "Wallet: $walletIndex \nBalance: $balance";
        });
      },
      child: Text('Get Balance $walletIndex'),
    );
  }
}
