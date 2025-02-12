import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'payment_config_model.dart';
export 'payment_config_model.dart';

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

