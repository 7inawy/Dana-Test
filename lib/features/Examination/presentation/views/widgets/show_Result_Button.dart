import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/features/Examination/presentation/views/widgets/result_Bottom_Sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dana/features/Examination/data/model/sensory_test_models.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../providers/app_theme_provider.dart';

class ShowResultButton extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final VoidCallback? onTap;
  final SensoryTestResult? result;

  const ShowResultButton({
    super.key,
    required this.isEnabled,
    required this.label,
    this.result,
    this.onTap,
  }) : assert(
          onTap != null || result != null,
          'Either provide onTap or a non-null result.',
        );

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: double.infinity,
      color: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      child: CustomButton(
        color: isEnabled
            ? (isDark
                  ? AppColors.button_primary_default_dark
                  : AppColors.button_primary_default_light)
            : (isDark
                  ? AppColors.bg_button_primary_disabled_dark
                  : AppColors.bg_button_primary_disabled_light),
        text: label,
        textColor: isEnabled
            ? (isDark
                  ? AppColors.text_button_dark
                  : AppColors.text_button_light)
            : (isDark
                  ? AppColors.text_button_disabled_dark
                  : AppColors.text_button_disabled_light),
        borderColor: isEnabled
            ? (isDark
                  ? AppColors.button_primary_default_dark
                  : AppColors.button_primary_default_light)
            : (isDark
                  ? AppColors.bg_button_primary_disabled_dark
                  : AppColors.bg_button_primary_disabled_light),
        onTap: isEnabled
            ? () {
                if (onTap != null) {
                  onTap!.call();
                  return;
                }
                final r = result;
                if (r != null) {
                  ResultBottomSheet.show(context, result: r);
                }
              }
            : () {},
      ),
    );
  }
}
