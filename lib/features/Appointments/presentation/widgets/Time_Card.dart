import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TimeCard extends StatelessWidget {
  final String textTime;
  final bool isSelected;
  final bool isDisabled;

  const TimeCard({
    super.key,
    required this.textTime,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      child: Container(
        width: 92.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDark
                    ? AppColors.bg_surface_subtle_dark
                    : AppColors.bg_surface_subtle_light)
              : isSelected
              ? (isDark
                    ? AppColors.primary_500_dark
                    : AppColors.primary_500_light)
              : (isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDisabled
                ? (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light)
                : isSelected
                ? (isDark
                      ? AppColors.border_button_primary_dark
                      : AppColors.border_button_primary_light)
                : (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light),
            width: 0.6.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textTime,
                style: isSelected
                    ? AppTextStyle.bold12TextButton(context)
                    : isDisabled
                    ? AppTextStyle.bold12TextHeading(context).copyWith(
                      color: isDark
                          ? AppColors.text_body_dark
                          : AppColors.text_body_light,
                    )
                    : AppTextStyle.bold12TextHeading(context),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.access_time,
                color: isDisabled
                    ? (isDark
                          ? AppColors.icon_onLight_dark
                          : AppColors.icon_onLight_light)
                    : isSelected
                    ? (isDark
                          ? AppColors.icon_onDark_dark
                          : AppColors.icon_onDark_light)
                    : (isDark
                          ? AppColors.icon_onLight_dark
                          : AppColors.icon_onLight_light),
                size: 16.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
