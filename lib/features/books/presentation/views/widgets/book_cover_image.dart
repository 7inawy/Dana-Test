import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../providers/app_theme_provider.dart';

class BookCoverImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  /// When false, no [ClipRRect] — use when an ancestor already clips (e.g. book cards).
  final bool clipInWidget;

  const BookCoverImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.clipInWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final w = width ?? 92.w;
    final h = height ?? 120.h;
    final trimmed = imageUrl.trim();
    final child = trimmed.isEmpty
        ? _placeholder(isDark, w, h)
        : (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
            ? Image.network(
                trimmed,
                width: w,
                height: h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(isDark, w, h),
              )
            : Image.asset(
                trimmed,
                width: w,
                height: h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(isDark, w, h),
              );

    if (!clipInWidget) {
      return SizedBox(width: w, height: h, child: child);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius_sm),
      child: child,
    );
  }

  Widget _placeholder(bool isDark, double w, double h) {
    return Container(
      width: w,
      height: h,
      color: isDark
          ? AppColors.bg_card_default_dark
          : AppColors.bg_card_default_light,
      child: Icon(
        Icons.book,
        color: isDark
            ? AppColors.primary_default_dark
            : AppColors.primary_default_light,
      ),
    );
  }
}
