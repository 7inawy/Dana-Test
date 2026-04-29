import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ThemeModeExtension on BuildContext {
  /// Theme brightness that *listens* to [AppThemeProvider] changes.
  bool get isDarkModeWatch {
    final themeProvider = watch<AppThemeProvider>();
    return themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(this).platformBrightness == Brightness.dark);
  }

  /// Theme brightness that *does not listen* to [AppThemeProvider] changes.
  bool get isDarkModeRead {
    final themeProvider = read<AppThemeProvider>();
    return themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(this).platformBrightness == Brightness.dark);
  }
}

