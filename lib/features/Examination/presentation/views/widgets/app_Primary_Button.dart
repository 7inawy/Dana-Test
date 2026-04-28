import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../providers/app_theme_provider.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppPrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? AppColors.primary_default_dark
            : AppColors.primary_default_light,
        foregroundColor: AppColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: 13.5.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius_lg),
          side: BorderSide(
            color: isDark
                ? AppColors.border_button_primary_dark
                : AppColors.border_button_primary_light,
            width: AppRadius.stroke_thin,
          ),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: AppTextStyle.semibold16TextButton(context),
      ),
    );
  }
}
