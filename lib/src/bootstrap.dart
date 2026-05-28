import 'package:fitmitra/src/app.dart';
import 'package:fitmitra/src/core/config/firebase_bootstrap.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseState = await FirebaseBootstrap.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        firebaseBootstrapProvider.overrideWithValue(firebaseState),
      ],
      child: const FitMitraApp(),
    ),
  );
}
