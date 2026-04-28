import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.suffixText,
    this.inputType,
    this.onChange,
    this.icon,
    this.maxLength,
    this.controller,
    this.inputFormatter,
    this.readOnly = false,
    this.onTap,
  });

  final String hintText;
  final String? suffixText;
  final TextInputType? inputType;
  final Function(String)? onChange;
  final IconData? icon;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return TextField(
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatter,
      controller: controller,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      maxLength: maxLength,
      style: AppTextStyle.medium12TextHeading(context),
      onChanged: onChange,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.regular12TextBody(context),
        suffixText: suffixText,
        suffixStyle: AppTextStyle.semibold12TextHeading(context),

        suffixIcon: icon != null
            ? Icon(
                icon,
                color: isDark
                    ? AppColors.text_body_dark
                    : AppColors.text_body_light,
              )
            : null,

        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        filled: true,
        fillColor: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius_sm),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: 1.5.w,
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
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius_sm),
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
      ),
    );
  }
}
