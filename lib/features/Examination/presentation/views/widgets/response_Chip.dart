import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';

class ResponseChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ResponseChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final primaryColor = isDark
        ? AppColors.primary_default_dark
        : AppColors.primary_default_light;

    final borderColor = isDark
        ? AppColors.border_card_default_dark
        : AppColors.border_card_default_light;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light)
              : (isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light),
          borderRadius: BorderRadius.circular(AppRadius.radius_xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : (isDark
                          ? AppColors.bg_card_default_dark
                          : AppColors.bg_card_default_light),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : borderColor,
                  width: 1.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.bg_surface_default_dark
                              : AppColors.bg_surface_default_light,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? AppTextStyle.semibold12TextHeading(context)
                    : AppTextStyle.medium12TextBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
