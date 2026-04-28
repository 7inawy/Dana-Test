import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../providers/app_theme_provider.dart';

class CustomTextRich extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final Color? dividerColor;

  const CustomTextRich({
    super.key,
    this.text,
    this.textStyle,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            width: 1,
            color:
                dividerColor ??
                (isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text ?? AppLocalizations.of(context)!.registerWith,
            style: textStyle ?? AppTextStyle.medium12TextDisplay(context),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            color:
                dividerColor ??
                (isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light),
          ),
        ),
      ],
    );
  }
}
