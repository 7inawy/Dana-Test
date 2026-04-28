import 'package:flutter/material.dart';

import '../core/theme/AppThemeHelper.dart';

class MyThemeData {
  final apptheme = AppThemeHelper();
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffF9FAFA),
  );
}
