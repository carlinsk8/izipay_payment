import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IzipayPayment {
  static const MethodChannel _channel = MethodChannel('izipay_payment_flutter');

  Future<String> startPayment(PaymentConfig config) async {
    try {
      final response = await _channel.invokeMethod('startPayment', config.toJson());
      if (kDebugMode) {
        print('Payment response: $response');
      }
      return '$response';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error initiating payment: ${e.message}");
      }
      return e.message ?? 'Error initiating payment';
    }
  }

  Future<void> getPaymentResult() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'paymentResult') {
        String paymentResponse = call.arguments;
        if (kDebugMode) {
          print("Payment response: $paymentResponse");
        }
      }
    });
  }
}


class PaymentConfig {
  final String environment;
  final String action;
  final String clientId;
  final String merchantId;
  final Order order;
  final Billing billing;
  final Shipping shipping;
  final Appearance appearance;

  PaymentConfig({
    required this.environment,
    required this.action,
    required this.clientId,
    required this.merchantId,
    required this.order,
    required this.billing,
    required this.shipping,
    required this.appearance,
  });

  Map<String, dynamic> toJson() {
    return {
      'environment': environment,
      'action': action,
      'clientId': clientId,
      'merchantId': merchantId,
      'order': order.toJson(),
      'billing': billing.toJson(),
      'shipping': shipping.toJson(),
      'appearance': appearance.toJson(),
    };
  }
  factory PaymentConfig.fromJson(Map<String, dynamic> json) {
    return PaymentConfig(
      environment: json['environment'],
      action: json['action'],
      clientId: json['clientId'],
      merchantId: json['merchantId'],
      order: Order.fromJson(json['order']),
      billing: Billing.fromJson(json['billing']),
      shipping: Shipping.fromJson(json['shipping']),
      appearance: Appearance.fromJson(json['appearance']),
    );
  }
}

class Order {
  final String currency;
  final String amount;
  final String email;

  Order({
    required this.currency,
    required this.amount,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'amount': amount,
      'email': email,
    };
  }
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      currency: json['currency'],
      amount: json['amount'],
      email: json['email'],
    );
  }
}

class Billing {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String region;
  final String country;
  final String postalCode;
  final String idType;
  final String idNumber;

  Billing({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
    required this.idType,
    required this.idNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'region': region,
      'country': country,
      'postalCode': postalCode,
      'idType': idType,
      'idNumber': idNumber,
    };
  }
  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      region: json['region'],
      country: json['country'],
      postalCode: json['postalCode'],
      idType: json['idType'],
      idNumber: json['idNumber'],
    );
  }
}

class Shipping {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String region;
  final String country;
  final String postalCode;
  final String idType;
  final String idNumber;

  Shipping({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
    required this.idType,
    required this.idNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'region': region,
      'country': country,
      'postalCode': postalCode,
      'idType': idType,
      'idNumber': idNumber,
    };
  }
  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      region: json['region'],
      country: json['country'],
      postalCode: json['postalCode'],
      idType: json['idType'],
      idNumber: json['idNumber'],
    );
  }
}

class Appearance {
  final String language;
  final String themeColor;
  final String primaryColor;
  final String secondaryColor;
  final String tertiaryColor;
  final String logoUrl;

  Appearance({
    required this.language,
    required this.themeColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.logoUrl,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      language: json['language'],
      themeColor: json['themeColor'],
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      tertiaryColor: json['tertiaryColor'],
      logoUrl: json['logoUrl'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'themeColor': themeColor,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'tertiaryColor': tertiaryColor,
      'logoUrl': logoUrl,
    };
  }
  
}