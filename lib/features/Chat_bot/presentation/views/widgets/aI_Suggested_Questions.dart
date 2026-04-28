import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class AISuggestedQuestions extends StatelessWidget {
  final List<String> questions;
  final Function(String) onQuestionTap;

  const AISuggestedQuestions({
    super.key,
    required this.questions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '✨ ${AppLocalizations.of(context)!.suggestedQuestionsHint}',
            style: AppTextStyle.medium16TextHeading(context),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 8.h,
            children: questions
                .map(
                  (q) => _QuestionChip(label: q, onTap: () => onQuestionTap(q)),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _QuestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primary_50_dark
              : AppColors.primary_50_light,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isDark
                ? AppColors.border_button_outlined_dark
                : AppColors.border_button_outlined_light,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.regular12TextBody(context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
