import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

class OtpResendSection extends StatelessWidget {
  final int remainingSeconds;
  final bool canResend;
  final VoidCallback onResend;

  const OtpResendSection({
    super.key,
    required this.remainingSeconds,
    required this.canResend,
    required this.onResend,
  });

  String get _timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text(
            AppLocalizations.of(context)!.resendCode,
            style: AppTextStyle.medium16PrimaryDefault(context).copyWith(
              color: isDark
                  ? AppColors.primary_default_dark
                  : AppColors.primary_default_light,
              decoration: TextDecoration.underline,
              decorationColor: isDark
                  ? AppColors.primary_default_dark
                  : AppColors.primary_default_light,
            ),
          ),
        ),
        SizedBox(width: AppSizes.w8),
        if (!canResend)
          Text(
            _timerText,
            style: AppTextStyle.medium12TextBody(context).copyWith(
              color: isDark
                  ? AppColors.text_body_dark
                  : AppColors.text_body_light,
            ),
          ),
      ],
    );
  }
}
