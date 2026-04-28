import 'package:dana/core/utils/app_raduis.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';

class BookDivider extends StatelessWidget {
  final int pageNumber;

  const BookDivider({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final color = isDark
        ? AppColors.secondary_default_dark
        : AppColors.secondary_default_light;

    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 6.w),
        Expanded(child: Divider(height: 1, color: color)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Transform.rotate(
            angle: 0.785,
            child: Container(
              width: 24.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.secondary_default_light
                    : AppColors.secondary_default_dark,
                borderRadius: BorderRadius.circular(AppRadius.radius_xs),
              ),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.785,
                child: Text(
                  '$pageNumber',
                  style: AppTextStyle.medium12TextHeading(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, color: color)),
        Icon(Icons.circle, color: color, size: 6.w),
      ],
    );
  }
}
