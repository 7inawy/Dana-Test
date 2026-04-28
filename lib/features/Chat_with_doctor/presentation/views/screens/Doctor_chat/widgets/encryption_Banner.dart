import 'package:dana/core/utils/app_assets.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_raduis.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../providers/app_theme_provider.dart';

class EncryptionBanner extends StatelessWidget {
  const EncryptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      padding: EdgeInsets.all(AppRadius.space_md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_success_subtle_dark
            : AppColors.bg_success_subtle_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Image.asset(
                AppAssets.elements,
                width: 14.w,
                height: 14.h,
                color: isDark
                    ? AppColors.success_default_dark
                    : AppColors.success_default_light,
              ),

              Text(
                AppLocalizations.of(context)!.endToEndEncrypted,
                style: AppTextStyle.medium16TextSuccess(context),
              ),
            ],
          ),
          SizedBox(height: AppRadius.space_md),
          Text(
            AppLocalizations.of(context)!.encryptionSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.regular12TextBody(context),
          ),
        ],
      ),
    );
  }
}
