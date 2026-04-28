import 'package:dana/features/Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/arrow_Painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';

class ArrowIcon extends StatelessWidget {
  final bool isRtl;

  const ArrowIcon({super.key, required this.isRtl});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SizedBox(
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
    );
  }
}
