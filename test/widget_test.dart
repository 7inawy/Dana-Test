// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dana/main.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/providers/app_language_provider.dart';
import 'package:dana/providers/app_theme_provider.dart';

void main() {
  testWidgets('App builds (smoke test)', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await sl.reset();
    await init();

    final themeProvider = AppThemeProvider();
    await themeProvider.loadTheme();

    final languageProvider = AppLanguageProvider();
    await languageProvider.loadLanguage();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider.value(value: themeProvider),
        ],
        child: const Dana(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
