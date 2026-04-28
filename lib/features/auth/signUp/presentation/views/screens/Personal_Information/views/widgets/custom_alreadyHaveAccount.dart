import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../providers/app_theme_provider.dart';

class CustomAlreadyHaveAccount extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final VoidCallback? onTap;

  const CustomAlreadyHaveAccount({
    super.key,
    required this.textOne,
    required this.textTwo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(textOne, style: AppTextStyle.regular16TextBody(context)),
          SizedBox(width: 4.w),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              textTwo,
              style: AppTextStyle.medium14PrimaryDefault(context).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
