import 'package:firebase_core/firebase_core.dart';

class FirebaseBootstrapState {
  const FirebaseBootstrapState({
    required this.isConfigured,
    this.app,
    this.message,
  });

  final bool isConfigured;
  final FirebaseApp? app;
  final String? message;

  bool get isDemoMode => !isConfigured;
}

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<FirebaseBootstrapState> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseBootstrapState(
          isConfigured: true,
          app: Firebase.app(),
          message: 'Connected to Firebase.',
        );
      }

      final app = await Firebase.initializeApp();
      return FirebaseBootstrapState(
        isConfigured: true,
        app: app,
        message: 'Connected to Firebase.',
      );
    } catch (error) {
      return FirebaseBootstrapState(
        isConfigured: false,
        message:
            'Firebase is not configured yet. The app runs in guided demo mode until FlutterFire setup is completed.\n$error',
      );
    }
  }
}
