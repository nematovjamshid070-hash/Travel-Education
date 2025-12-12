import 'package:flutter/foundation.dart';

/// API configuration.
///
/// For Android Emulator use: http://10.0.2.2:3000
/// For Web (Chrome) use:     http://localhost:3000
///
/// If you run on a real phone, set this to your PC IP address:
/// e.g. http://192.168.1.10:3000
class AppConfig {
  static const int apiPort = 3000;

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$apiPort';
    }
    // Default for Android emulator. Change if you use real device or iOS.
    return 'http://10.0.2.2:$apiPort';
  }
}
