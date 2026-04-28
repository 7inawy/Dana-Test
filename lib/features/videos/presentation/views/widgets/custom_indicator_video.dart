import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../providers/app_theme_provider.dart';

class CustomIndicatorVideo extends StatelessWidget {
  const CustomIndicatorVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SizedBox(
      width: double.infinity,
      height: 24.h,
      child: Center(
        child: Container(
          width: 134.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
