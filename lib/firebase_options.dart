import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Replace this file by running `flutterfire configure` before production
/// release. The app only reads these values when
/// FITMITRA_FIREBASE_CONFIGURED=true is passed with --dart-define.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError('Firebase options are not configured for Linux.');
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Firebase options are not configured for Fuchsia.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'fitmitra-prod',
    authDomain: 'fitmitra-prod.firebaseapp.com',
    storageBucket: 'fitmitra-prod.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'fitmitra-prod',
    storageBucket: 'fitmitra-prod.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'fitmitra-prod',
    storageBucket: 'fitmitra-prod.appspot.com',
    iosBundleId: 'com.epointdigital.fitmitra',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WINDOWS_API_KEY',
    appId: 'REPLACE_WITH_WINDOWS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'fitmitra-prod',
    authDomain: 'fitmitra-prod.firebaseapp.com',
    storageBucket: 'fitmitra-prod.appspot.com',
  );
}
