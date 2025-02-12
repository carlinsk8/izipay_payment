# izipay_payment

A Flutter plugin to integrate the official Izipay SDKs on Android and iOS, allowing payments directly in Flutter applications.

📌 Official documentation:
- [Android SDK](https://developers.izipay.pe/android-core/)
- [iOS SDK](https://developers.izipay.pe/ios-core)

---

## Platform Support

This package supports the following platforms:

✅ **Android**  
✅ **iOS**  
❌ **Windows** (Not Supported)  
❌ **macOS** (Not Supported)  
❌ **Linux** (Not Supported)  
❌ **Web** (Not Supported)  

This plugin is designed to work exclusively on **Android** and **iOS**.  
For more details, refer to the official documentation.  

<p align="center">
  <img src="https://github.com/carlinsk8/izipay_payment/blob/main/assets/screenshot/form_android.jpg" width="45%" alt="Android Form">
  <img src="https://github.com/carlinsk8/izipay_payment/blob/main/assets/screenshot/form_ios.jpg" width="45%" alt="iOS Form">
</p>


## 🚀 Configuration on Android

### 1. Pre-configuration
Some configurations are necessary before using the SDK on Android.

### 2. Configure `build.gradle` (app module)
Add the following lines in `android/app/build.gradle`:

```gradle
plugins {
  id 'kotlin-kapt'
  id 'dagger.hilt.android.plugin'
}

dependencies {
   implementation "com.google.dagger:hilt-android:2.44"
   kapt "com.google.dagger:hilt-compiler:2.44"
}
```

### 3. Configure `settings.gradle`
Add in `android/settings.gradle`:

```gradle
plugins {
   id "com.google.dagger.hilt.android" version "2.44" apply false
}
```

### 4. Create the `SDKExampleApp.kt` class
Create the file `SDKExampleApp.kt` at the path `android/app/src/main/kotlin/{your_package}/SDKExampleApp.kt`:

```kotlin
package com.izipay.payment.izipay_payment_example
import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class SDKExampleApp : Application() {
   override fun onCreate() {
      super.onCreate()
   }
}
```

### 5. Configure `AndroidManifest.xml`
Add the reference to `SDKExampleApp` within the `<application>` tag in `AndroidManifest.xml`:

```xml
<application
   android:name=".SDKExampleApp"
   ...>
</application>
```

---

## 🍏 Implementation on iOS

📌 Requires a minimum of iOS 13:
```text
platform :ios, '13.0'
```

---

## 🛠 Usage in Flutter

### 1. Add the dependency in `pubspec.yaml`
Add the library in `pubspec.yaml`:

```yaml
dependencies:
  izipay_payment_flutter:
   path: ../izipay_payment_flutter
```

### 2. Import the library and use the plugin
In the Flutter code, import the package and call the payment initiation method:

```dart
import 'package:izipay_payment_flutter/izipay_payment_flutter.dart';

Future<void> initPaymentIzipay() async {
   final config = {
    "environment": "SBOX", // SBOX, TEST, PROD
    "action": "register",
    "clientId": "<MERCHANT CODE>",
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
   final _izipayPaymentFlutterPlugin = IzipayPayment();
   try {
    response = await _izipayPaymentFlutterPlugin.startPayment(paymentConfig);
    // Send the response to the service
    print(response);
   } on PlatformException {
    response = 'Failed to get platform version.';
    setState(() {});
   }
}
```

---

## ✅ Example of a successful response

```json
{
	"code": "00",
	"message": "Operación exitosa",
	"response": {
		"orderNumber": "10366493777",
		"merchantBuyerId": "MB10366493777",
		"token": {
			"cardToken": "4e5e7a5244f68b22bf1907aa4fd99154d1689f17adff2e2d4993d2febada41a0"
		},
		"card": {
			"brand": "VS",
			"pan": "497010******0014"
		},
		"merchantCode": "4004353",
		"transactionId": "366493777",
		"facilitatorCode": ""
	},
	"header": {
		"transactionStartDatetime": "2025-02-12 12:39:32.902",
		"millis": 47216,
		"transactionEndDatetime": "2025-02-12 12:40:20.118"
	},
	"result": {
		"messageFriendly": "Operación exitosa"
	},
	"payload": "{\"code\":\"00\",\"message\":\"Operación exitosa\",\"messageUser\":\"Operación exitosa\",\"messageUserEng\":\"Successful\",\"transactionId\":\"366493777\",\"response\":{\"payMethod\":\"CARD\",\"order\":[{\"payMethodAuthorization\":\"CARD\",\"codeAuth\":\"\",\"currency\":\"PEN\",\"amount\":\"11.00\",\"installment\":\"00\",\"deferred\":\"0\",\"orderNumber\":\"10366493777\",\"stateMessage\":\"Autorizado\",\"dateTransaction\":\"20250212\",\"timeTransaction\":\"124013\",\"uniqueId\":\"\",\"referenceNumber\":\"\"}],\"card\":{\"brand\":\"VS\",\"pan\":\"497010******0014\",\"save\":\"true\"},\"billing\":{\"firstName\":\"Quispe\",\"lastName\":\"Juan\",\"email\":\"example@gmail.com\",\"phoneNumber\":\"989339999\",\"street\":\"Av. flores\",\"city\":\"Lima\",\"state\":\"Lima\",\"country\":\"PE\",\"postalCode\":\"33065\",\"documentType\":\"DNI\",\"document\":\"55555555\"},\"merchant\":{\"merchantCode\":\"4004353\",\"facilitatorCode\":\"\"},\"token\":{\"merchantBuyerId\":\"MB10366493777\",\"cardToken\":\"4e5e7a5244f68b22bf1907aa4fd99154d1689f17adff2e2d4993d2febada41a0\",\"alias\":\"\"},\"authentication\":{\"result\":\"\"},\"customFields\":[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],\"miles\":{\"netMiles\":\"\",\"miles\":\"\"}}}"
}
```

---

📌 **Notes:**
- Verify that the configuration values are correct according to the environment (sandbox, test, production).
- Properly handle platform errors to improve user experience.

🎯 Ready! Now you can integrate Izipay payments into your Flutter app. 🚀
