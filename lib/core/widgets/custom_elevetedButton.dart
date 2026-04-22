import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

/// widget=>elevetedButton
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isDisabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isIconAtStart;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.isIconAtStart = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final effectiveBackgroundColor =
        backgroundColor ??
        (isDark
            ? AppColors.button_primary_default_dark
            : AppColors.button_primary_default_light);

    final effectiveTextColor =
        textColor ??
        (isDisabled
            ? (isDark
                  ? AppColors.text_button_disabled_dark
                  : AppColors.text_button_disabled_light)
            : (isDark
                  ? AppColors.text_button_dark
                  : AppColors.text_button_light));

    final effectiveBorderColor =
        borderColor ??
        (isDark
            ? AppColors.border_button_primary_dark
            : AppColors.border_button_primary_light);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return backgroundColor ??
                  (isDark
                      ? AppColors.bg_button_primary_disabled_dark
                      : AppColors.bg_button_primary_disabled_light);
            }

            return effectiveBackgroundColor;
          }),

          foregroundColor: WidgetStateProperty.all(effectiveTextColor),

          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(vertical: 13.5.w),
          ),

          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_lg),
              side: BorderSide(
                color: isDisabled ? Colors.transparent : effectiveBorderColor,
                width: borderWidth ?? 0.6.w,
              ),
            ),
          ),

          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black12;
            }
            return null;
          }),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _buildButtonContent(isRTL, effectiveTextColor),
        ),
      ),
    );
  }

  List<Widget> _buildButtonContent(bool isRTL, Color effectiveTextColor) {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        color: effectiveTextColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 16.sp,
      ),
    );

    if (icon == null) return [textWidget];

    final iconWidget = Icon(icon, color: effectiveTextColor, size: 18.r);

    if (isIconAtStart) {
      return [iconWidget, SizedBox(width: 8.w), textWidget];
    }

    return [textWidget, SizedBox(width: 8.w), iconWidget];
  }
}

///لو انتي محددة isIconAtStart = true → يمشي على كلامك
//
// لو لا → يخلي الاتجاه حسب اللغة
//
// عربي → الأيقونة في البداية
//
// إنجليزي → الأيقونة في النهاية
