import 'package:dana/features/auth/login/presentation/views/screens/forget_password/screens/forget_password_page.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../providers/app_theme_provider.dart';

class LoginForgotPassword extends StatelessWidget {
  const LoginForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return GestureDetector(
      onTap: () => ForgetPasswordDialog.show(context),
      child: Text(
        AppLocalizations.of(context)!.forgotPassword,
        style: AppTextStyle.medium16PrimaryDefault(context).copyWith(
          decorationColor: isDark
              ? AppColors.primary_default_dark
              : AppColors.primary_default_light,
        ),
      ),
    );
  }
}
