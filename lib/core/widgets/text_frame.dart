import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TextFrame extends StatelessWidget {
  const TextFrame({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.vPadding = 24,
  });

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double vPadding;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      decoration: BoxDecoration(
        color:
            color ??
            (isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light),
        border: Border.all(
          color:
              borderColor ??
              (isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light),
          width: 0.8.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: vPadding.h),
        child: child,
      ),
    );
  }
}
