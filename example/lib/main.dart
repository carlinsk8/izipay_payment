import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:izipay_payment/izipay_payment.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _izipayPaymentFlutterPlugin = IzipayPayment();
  String response = '';

  // Inicialización de pago
  Future<void> initPaymentIzipay() async {
    final config = {
      "environment": "SBOX",//TEST o PROD o SBOX
      "action": "register",
      "clientId": "<CODIGO DE COMERCIO>",
      "merchantId": "<public key>",
      "order": {
        "currency": "PEN",
        "amount": "11.00",
        "email": "example@gmail.com"
      },
      "billing": {
        "firstName": "Juan",
        "lastName": "Quispe",
        "email": "example@gmail.com",
        "phone": "930292619",
        "address": "Av. flores",
        "city": "Lima",
        "region": "Lima",
        "country": "PE",
        "postalCode": "33065",
        "idType": "DNI",
        "idNumber": "55555555"
      },
      "shipping": {
        "firstName": "Juan",
        "lastName": "Quispe",
        "email": "example@gmail.com",
        "phone": "930292619",
        "address": "Av. Alamo",
        "city": "Lima",
        "region": "Lima",
        "country": "PE",
        "postalCode": "33065",
        "idType": "DNI",
        "idNumber": "55555555"
      },
      "appearance": {
        "language": "ESP",
        "themeColor": "green",
        "primaryColor": "#333399",
        "secondaryColor": "#333399",
        "tertiaryColor": "#333399",
        "logoUrl": "https://logowik.com/content/uploads/images/shopping-cart5929.jpg"
      }
    };
    final paymentConfig = PaymentConfig.fromJson(config);
    try {
      response = await _izipayPaymentFlutterPlugin.startPayment(paymentConfig);
      setState(() {});
    } on PlatformException {
      response = 'Failed to get platform version.';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: initPaymentIzipay,
                    child: const Text('Init IZIPAY'),
                  ),
                ],
              ),
              Text(response),
              if (response.isNotEmpty)
                Builder(
                  builder: (context) => TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: response));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    child: const Text('Copy to clipboard'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
