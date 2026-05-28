import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/app.dart';

void main() {
  testWidgets('FitMitra app starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FitMitraApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
