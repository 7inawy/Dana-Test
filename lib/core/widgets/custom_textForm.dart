import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

class CustomTextForm extends StatelessWidget {
  final String text;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final double? borderWidth;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextForm({
    super.key,
    required this.text,
    required this.hintText,
    this.icon,
    this.controller,
    this.validator,
    this.borderColor,
    this.borderWidth,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.medium12TextHeading(context)),
        SizedBox(height: AppSizes.h8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTextStyle.bold12TextHeading(context),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light,
            hintText: hintText,
            hintStyle: AppTextStyle.regular12TextBody(context),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            suffixIcon:
                suffixIcon ??
                (icon != null
                    ? Icon(
                        icon,
                        color: isDark
                            ? AppColors.primary_900_dark
                            : AppColors.primary_900_light,
                        size: 24,
                      )
                    : null),
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
                width: borderWidth ?? 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: Colors.red,
                width: borderWidth ?? 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
