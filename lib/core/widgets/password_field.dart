import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:provider/provider.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.text,
    this.controller,
    this.validator,
  });

  final String text;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,

      obscureText: _obscureText,
      obscuringCharacter: '*',
      style: AppTextStyle.medium12TextHeading(context),

      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@#$%^&*!_]')),
      ],

      decoration: InputDecoration(
        hintText: widget.text,
        hintStyle: AppTextStyle.regular12TextBody(context),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: isDark
                ? AppColors.icon_onLight_dark
                : AppColors.icon_onLight_light,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),

        filled: true,
        fillColor: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: 0.8.w,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: 0.8.w,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 213, 44, 44),
            width: 0.8.w,
          ),
        ),
      ),
    );
  }
}
