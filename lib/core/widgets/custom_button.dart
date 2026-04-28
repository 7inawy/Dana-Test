import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
    this.icon,
    this.iconSize,
    this.width = double.infinity,
    this.height,
    this.borderWidth,
    this.borderRadius,
    this.color,
    this.textStyle,
    this.textColor,
    this.borderColor,
  });

  final String? text;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double width;
  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final IconData? icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final isEnabled = enabled && !isLoading;
    final resolvedColor =
        color ??
        (isEnabled
            ? (isDark
                ? AppColors.button_primary_default_dark
                : AppColors.button_primary_default_light)
            : (isDark
                ? AppColors.bg_button_primary_disabled_dark
                : AppColors.bg_button_primary_disabled_light));
    final resolvedBorderColor =
        borderColor ??
        (isDark
            ? AppColors.border_button_primary_dark
            : AppColors.border_button_primary_light);
    final resolvedTextColor =
        textColor ??
        (isEnabled
            ? (isDark ? AppColors.text_button_dark : AppColors.text_button_light)
            : (isDark
                ? AppColors.text_button_disabled_dark
                : AppColors.text_button_disabled_light));

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppRadius.radius_lg,
          ),
          border: Border.all(
            color: resolvedBorderColor,
            width: borderWidth ?? AppRadius.stroke_thin,
          ),
          color: resolvedColor,
        ),
        width: width,
        height: height ?? 48.h,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      resolvedTextColor,
                    ),
                  ),
                ),
                if (text != null) SizedBox(width: 10.w),
              ],
              if (text != null)
                Text(
                  text!,
                  style:
                      textStyle ??
                      TextStyle(
                        color: resolvedTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        fontFamily: FontFamilies.ibm,
                      ),
                ),
              if (icon != null) ...[
                if (text != null) SizedBox(width: 8.w),
                Icon(
                  icon,
                  color: resolvedTextColor,
                  size: iconSize ?? 18.r,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
