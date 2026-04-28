import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';

class PageNumberBadge extends StatelessWidget {
  final int pageNumber;
  const PageNumberBadge({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Center(
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primary_default_dark
              : AppColors.primary_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        ),
        alignment: Alignment.center,
        child: Text(
          '$pageNumber',
          style: AppTextStyle.semibold16TextHeading(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
