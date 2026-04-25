import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/log/debug_audit_log.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode appTheme = ThemeMode.system;

  // تحميل الثيم
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedTheme = prefs.getInt('theme');

    DebugAuditLog.log(
      runId: 'pre-fix',
      hypothesisId: 'H1',
      location: 'lib/providers/app_theme_provider.dart:loadTheme',
      message: 'Loaded theme preference',
      data: {
        'savedTheme': savedTheme,
        'themeModeValuesLen': ThemeMode.values.length,
      },
    );

    if (savedTheme != null) {
      appTheme = ThemeMode.values[savedTheme];
    } else {
      appTheme = ThemeMode.system;
    }
  }

  // حفظ الثيم
  Future<void> changeTheme(ThemeMode newTheme) async {
    if (appTheme == newTheme) return;

    appTheme = newTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', newTheme.index);

    notifyListeners();
  }
}
