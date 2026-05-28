import 'package:flutter_test/flutter_test.dart';
import 'package:fitmitra/core/constants/app_constants.dart';

void main() {
  test('App constants are configured', () {
    expect(AppConstants.appName, 'FitMitra');
    expect(AppConstants.packageId, 'com.epointdigital.fitmitra');
  });
}
