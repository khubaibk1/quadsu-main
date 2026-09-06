// Smoke test for the Quadsu app.
//
// This previously held the untouched `flutter create` counter test, which
// asserted on a counter UI this app never had and failed on every run.
// Booting MyApp directly needs the full MultiProvider tree from main(), so
// this checks the theme resolves instead — enough to keep `flutter test`
// meaningful in CI without standing up the whole app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quadsu_app/themes/app_themes.dart';

void main() {
  test('light theme resolves', () {
    expect(CustomAppThemes.lightTheme, isA<ThemeData>());
  });
}
