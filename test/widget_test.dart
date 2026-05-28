import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic material shell renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('FitMitra test'),
        ),
      ),
    );
    expect(find.text('FitMitra test'), findsOneWidget);
  });
}
