import 'package:dana/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemeData {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bg_surface_default_light,
    textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(),
  );
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bg_surface_default_dark,
  );
}
