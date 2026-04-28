import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      margin: EdgeInsets.only(top: 21.h, bottom: 8.h),
      width: 134.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.border_card_default_dark
            : AppColors.border_card_default_light,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
