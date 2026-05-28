import 'package:fitmitra/src/app.dart';
import 'package:fitmitra/src/core/config/firebase_bootstrap.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('FitMitra boots to login experience', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          firebaseBootstrapProvider.overrideWithValue(
            const FirebaseBootstrapState(
              isConfigured: false,
              message: 'Demo mode active.',
            ),
          ),
        ],
        child: const FitMitraApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('FitMitra'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
