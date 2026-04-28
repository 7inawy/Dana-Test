import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../providers/app_theme_provider.dart';

class CustomAddChildButtonRow extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomAddChildButtonRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.w6),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.icon_onLight_dark
                  : AppColors.icon_onLight_light,
              borderRadius: BorderRadius.circular(AppSizes.r20),
            ),
            child: Icon(
              Icons.add,
              color: isDark
                  ? AppColors.bg_surface_default_dark
                  : AppColors.bg_surface_default_light,
              size: AppSizes.w24,
            ),
          ),
          SizedBox(width: AppSizes.w8),
          Text(
            AppLocalizations.of(context)!.addAnotherChild,
            style: AppTextStyle.medium16PrimaryDefault(context).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: isDark
                  ? AppColors.primary_default_dark
                  : AppColors.primary_default_light,
            ),
          ),
        ],
      ),
    );
  }
}
