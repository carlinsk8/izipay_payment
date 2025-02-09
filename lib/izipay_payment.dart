import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Handles Izipay payment integration using Flutter's MethodChannel.
class IzipayPayment {
  static const MethodChannel _channel = MethodChannel('izipay_payment_flutter');

  /// Starts a payment process with the given [config].
  /// Returns a response as a [String] or an error message if the process fails.
  Future<String> startPayment(PaymentConfig config) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError("Izipay is only supported on Android and iOS");
    }
    try {
      final response =
          await _channel.invokeMethod('startPayment', config.toJson());
      if (kDebugMode) {
        print('Payment response: $response');
      }
      if (Platform.isIOS) {
        return response[0];
      }
      return '$response';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error initiating payment: ${e.message}");
      }
      return e.message ?? 'Error initiating payment';
    }
  }
}

/// Represents the payment configuration.
class PaymentConfig {
  /// The environment for the payment process.
  final String environment;

  /// The action to be performed.
  final String action;

  /// The client ID for the payment process.
  final String clientId;

  /// The merchant ID for the payment process.
  final String merchantId;

  /// The order details for the payment process.
  final Order order;

  /// The billing details for the payment process.
  final Billing billing;

  /// The shipping details for the payment process.
  final Shipping shipping;

  /// The appearance settings for the payment process.
  final Appearance appearance;

  /// Creates a new instance of [PaymentConfig] with the given parameters.
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

  /// Converts the [PaymentConfig] instance to a JSON object.
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

  /// Creates a new instance of [PaymentConfig] from a JSON object.
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

/// Represents an order in the payment process.
class Order {
  /// The currency for the order.
  final String currency;

  /// The amount for the order.
  final String amount;

  /// The email associated with the order.
  final String email;

  /// Creates a new instance of [Order] with the given parameters.
  Order({
    required this.currency,
    required this.amount,
    required this.email,
  });

  /// Converts the [Order] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'amount': amount,
      'email': email,
    };
  }

  /// Creates a new instance of [Order] from a JSON object.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      currency: json['currency'],
      amount: json['amount'],
      email: json['email'],
    );
  }
}

/// Represents the billing details for the payment process.
class Billing {
  /// The first name of the billing contact.
  final String firstName;

  /// The last name of the billing contact.
  final String lastName;

  /// The email address of the billing contact.
  final String email;

  /// The phone number of the billing contact.
  final String phone;

  /// The address of the billing contact.
  final String address;

  /// The city of the billing contact.
  final String city;

  /// The region of the billing contact.
  final String region;

  /// The country of the billing contact.
  final String country;

  /// The postal code of the billing contact.
  final String postalCode;

  /// The ID type of the billing contact.
  final String idType;

  /// The ID number of the billing contact.
  final String idNumber;

  /// Creates a new instance of [Billing] with the given parameters.
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

  /// Converts the [Billing] instance to a JSON object.
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

  /// Creates a new instance of [Billing] from a JSON object.
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

/// Represents the shipping details for the payment process.
class Shipping {
  /// The first name of the shipping contact.
  final String firstName;

  /// The last name of the shipping contact.
  final String lastName;

  /// The email address of the shipping contact.
  final String email;

  /// The phone number of the shipping contact.
  final String phone;

  /// The address of the shipping contact.
  final String address;

  /// The city of the shipping contact.
  final String city;

  /// The region of the shipping contact.
  final String region;

  /// The country of the shipping contact.
  final String country;

  /// The postal code of the shipping contact.
  final String postalCode;

  /// The ID type of the shipping contact.
  final String idType;

  /// The ID number of the shipping contact.
  final String idNumber;

  /// Creates a new instance of [Shipping] with the given parameters.
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

  /// Converts the [Shipping] instance to a JSON object.
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

  /// Creates a new instance of [Shipping] from a JSON object.
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

/// Represents the appearance settings for the payment process.
class Appearance {
  /// The language for the appearance settings.
  final String language;

  /// The theme color for the appearance settings.
  final String themeColor;

  /// The primary color for the appearance settings.
  final String primaryColor;

  /// The secondary color for the appearance settings.
  final String secondaryColor;

  /// The tertiary color for the appearance settings.
  final String tertiaryColor;

  /// The URL of the logo for the appearance settings.
  final String logoUrl;

  /// Creates a new instance of [Appearance] with the given parameters.
  Appearance({
    required this.language,
    required this.themeColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.logoUrl,
  });

  /// Creates a new instance of [Appearance] from a JSON object.
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

  /// Converts the [Appearance] instance to a JSON object.
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
