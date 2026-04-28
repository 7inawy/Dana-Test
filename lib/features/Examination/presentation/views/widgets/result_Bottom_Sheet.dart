import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/features/Examination/presentation/views/widgets/result_Content.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/sensory_test_models.dart';
import 'result_Image.dart';

class ResultBottomSheet extends StatelessWidget {
  final SensoryTestResult result;

  const ResultBottomSheet({super.key, required this.result});

  static void show(BuildContext context, {required SensoryTestResult result}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResultBottomSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final l10n = AppLocalizations.of(context)!;
    final scoreLine = (result.maxScore != null && result.maxScore! > 0)
        ? '${result.totalScore} / ${result.maxScore}'
        : '${result.totalScore}';
    final percentageLine = result.percentage != null
        ? ' (${result.percentage!.toStringAsFixed(1)}%)'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_surface_default_dark
            : AppColors.bg_surface_default_light,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HomeIndicator(),
          SizedBox(height: 24.h),
          ResultImage(imagePath: AppAssets.exam_1),
          SizedBox(height: 24.h),
          ResultContent(
            titleColor: AppColors.success_default_light,
            title: l10n.resultNormalTitle,
            description: '${l10n.resultNormalDescription}\n\n$scoreLine$percentageLine',
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 32.h),
            child: CustomButton(
              text: l10n.browseActivities,
              onTap: () {
                // Normal (low) result: just close the sheet.
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
