import 'package:dana/core/utils/app_raduis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_text_style.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../providers/app_theme_provider.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 48.h,
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.button_primary_default_dark
              : AppColors.button_primary_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_lg),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.border_button_primary_dark
                  : AppColors.border_button_primary_light,
              width: 0.6,
            ),
          ),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.viewProfile,
            textAlign: TextAlign.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.semibold16TextButton(context),
          ),
        ),
      ),
    );
  }
}
