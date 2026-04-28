import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SelectableOption extends StatelessWidget {
  final String text;
  final String imagePath;
  final int value;
  final int? selectedValue;
  final Function(int) onChanged;

  const SelectableOption({
    super.key,
    required this.text,
    required this.imagePath,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bool isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        height: 72.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.bg_button_primary_disabled_dark
                    : AppColors.bg_button_primary_disabled_light)
              : (isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? (isDark
                      ? AppColors.border_button_primary_dark
                      : AppColors.border_button_primary_light)
                : (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light),
            width: AppRadius.stroke_regular,
          ),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 24.h, width: 24.w),
            SizedBox(width: AppSizes.w8),
            Expanded(
              child: Text(text, style: AppTextStyle.bold16TextHeading(context)),
            ),
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDark
                            ? AppColors.primary_default_dark
                            : AppColors.primary_default_light)
                      : (isDark
                            ? AppColors.border_card_default_dark
                            : AppColors.border_card_default_light),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: AppSizes.w8,
                        height: AppSizes.h8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.primary_default_dark
                              : AppColors.primary_default_light,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
