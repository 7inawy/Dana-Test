import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddChildCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddChildCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 119.w,
        padding: EdgeInsets.symmetric(vertical: 28.5.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.button_primary_default_dark
              : AppColors.button_primary_default_light,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark
                ? AppColors.border_button_outlined_dark
                : AppColors.border_button_outlined_light,
            width: AppRadius.stroke_more_thin,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 24.sp,
                  color: isDark
                      ? AppColors.icon_onLight_dark
                      : AppColors.icon_onLight_light,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              context.l10n.addNewChild,
              style: AppTextStyle.semibold12TextButton(context),
            ),
          ],
        ),
      ),
    );
  }
}
