import 'package:dana/core/utils/app_raduis.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import 'arrow_Painter.dart';

class ChatBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isRtl;

  const ChatBackButton({
    super.key,
    required this.onPressed,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bg_surface_subtle_dark
              : AppColors.bg_surface_subtle_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_sm),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              width: 0.6,
            ),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.h,
            child: CustomPaint(
              painter: ArrowPainter(
                color: isDark
                    ? AppColors.text_heading_dark
                    : AppColors.text_heading_light,
                strokeWidth: 1.5,
                isRtl: isRtl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
