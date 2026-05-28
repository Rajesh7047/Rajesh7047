import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/main.dart';

void main() {
  testWidgets('FitMitra app launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FitMitraApp()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
