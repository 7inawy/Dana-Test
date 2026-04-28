import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key, required this.value, this.height});

  final int value;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return LayoutBuilder(
      builder: (context, constraints) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.toDouble()),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          builder: (context, animatedValue, child) {
            return Stack(
              children: [
                Container(
                  height: height ?? 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.bg_surface_subtle_dark
                        : AppColors.bg_surface_subtle_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  ),
                ),

                Container(
                  height: height ?? 6.h,
                  width: constraints.maxWidth * (animatedValue / 100),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary_default_dark
                        : AppColors.primary_default_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
