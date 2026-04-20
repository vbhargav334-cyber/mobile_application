import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Lazily initialises Firebase if enabled. Falls back silently when
/// configuration files are missing so the app still boots in demo mode.
class FirebaseBootstrap {
  static bool _initialized = false;
  static bool get initialized => _initialized;

  static Future<void> init() async {
    if (!AppConstants.useFirebase) {
      debugPrint('[FirebaseBootstrap] Skipping Firebase init (demo mode).');
      return;
    }
    try {
      await Firebase.initializeApp();
      _initialized = true;
      debugPrint('[FirebaseBootstrap] Firebase initialized.');
    } catch (e) {
      debugPrint(
        '[FirebaseBootstrap] Firebase init failed ($e). Falling back to demo mode.',
      );
    }
  }
}
