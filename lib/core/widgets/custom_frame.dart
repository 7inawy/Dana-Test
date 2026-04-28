import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomFrame extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final double? radius;
  final double? hPadding;
  final double? vPadding;
  final Color? color;

  const CustomFrame({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.radius,
    this.hPadding,
    this.vPadding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color:
            color ??
            (isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light),
        borderRadius: BorderRadius.circular(radius ?? AppRadius.radius_lg),
        border: Border.all(
          width: AppRadius.stroke_regular,
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: vPadding ?? 16.h,
          horizontal: hPadding ?? 16.w,
        ),
        child: child,
      ),
    );
  }
}
