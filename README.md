# izipay_payment

Un plugin de Flutter para integrar los SDK oficiales de Izipay en Android e iOS, permitiendo realizar pagos directamente en aplicaciones Flutter.

📌 Documentación oficial:
- [Android SDK](https://developers.izipay.pe/android-core/)
- [iOS SDK](https://developers.izipay.pe/ios-core)

---

## 🚀 Configuración en Android

### 1. Configuración previa
Es necesario realizar algunas configuraciones antes de utilizar el SDK en Android.

### 2. Configurar `build.gradle` (módulo app)
Añadir las siguientes líneas en `android/app/build.gradle`:

```gradle
plugins {
   id 'kotlin-kapt'
   id 'dagger.hilt.android.plugin'
}

dependencies {
    implementation "com.google.dagger:hilt-android:2.44"
    kapt "com.google.dagger:hilt-compiler:2.44"
}

javaCompileOptions {
    sourceCompatibility JavaVersion.VERSION_17
    targetCompatibility JavaVersion.VERSION_17
}
```

### 3. Configurar `settings.gradle`
Añadir en `android/settings.gradle`:

```gradle
plugins {
    id "com.google.dagger.hilt.android" version "2.44" apply false
}
```

### 4. Crear la clase `SDKExampleApp.kt`
Crear el archivo `SDKExampleApp.kt` en la ruta `android/app/src/main/kotlin/{tu_paquete}/SDKExampleApp.kt`:

```kotlin
import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class SDKExampleApp : Application() {
    override fun onCreate() {
        super.onCreate()
    }
}
```

### 5. Configurar `AndroidManifest.xml`
Agregar la referencia a `SDKExampleApp` dentro de la etiqueta `<application>` en `AndroidManifest.xml`:

```xml
<application
    android:name=".SDKExampleApp"
    ...>
</application>
```

---

## 🍏 Implementación en iOS

📌 Requiere un mínimo de iOS 13:
```text
platform :ios, '13.0'
```

---

## 🛠 Uso en Flutter

### 1. Agregar la dependencia en `pubspec.yaml`
Añadir la librería en `pubspec.yaml`:

```yaml
dependencies:
  izipay_payment_flutter:
    path: ../izipay_payment_flutter
```

### 2. Importar la librería y usar el plugin
En el código de Flutter, importar el paquete y llamar al método de inicio de pago:

```dart
import 'package:izipay_payment_flutter/izipay_payment_flutter.dart';

Future<void> initPaymentIzipay() async {
    final config = {
      "environment": "SBOX", // SBOX, TEST, PROD
      "action": "register",
      "clientId": "VErethUtraQuxas57wuMuquprADrAHAb",
      "merchantId": "4004353",
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
        "logoUrl": "https://guinea.pe/wp-content/uploads/2024/05/08.png"
      }
    };
    final paymentConfig = PaymentConfig.fromJson(config);
    try {
      response = await _izipayPaymentFlutterPlugin.startPayment(paymentConfig);
      // Se envía el response al servicio
      print(response);
    } on PlatformException {
      response = 'Failed to get platform version.';
      setState(() {});
    }
}
```

---

## ✅ Ejemplo de respuesta exitosa

```json
{
  "code": "00",
  "message": "OK",
  "header": {
    "transactionStartDatetime": "2025-02-06 09:40:40.879",
    "transactionEndDatetime": "2025-02-06 09:41:15.552",
    "millis": 34674
  },
  "response": {
    "merchantCode": "4004353",
    "facilitatorCode": "",
    "merchantBuyerId": "MB101738852840885",
    "card": {
      "brand": "VS",
      "pan": "497010**0014"
    },
    "token": {
      "token": "118ea63399a6fb4e06d41789189d1bc8bf480f6470be169ba2b54c70d36cfd94"
    }
  },
  "result": {
    "messageFriendly": "Operación exitosa"
  }
}
```

---

📌 **Notas:**
- Verifica que los valores de configuración sean correctos según el entorno (sandbox, test, producción).
- Maneja correctamente los errores de plataforma para mejorar la experiencia del usuario.

🎯 ¡Listo! Ahora puedes integrar pagos con Izipay en tu app Flutter. 🚀

