import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/features/Examination/presentation/views/widgets/question_Item.dart';
import 'package:dana/features/Examination/presentation/views/widgets/section_Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/examination_model.dart';

class ExamSectionCard extends StatelessWidget {
  final ExamSection section;
  final Function(int questionIndex, ResponseOption option) onAnswerChanged;

  const ExamSectionCard({
    super.key,
    required this.section,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_surface_subtle_dark
            : AppColors.bg_surface_subtle_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        border: Border.all(
          width: AppRadius.stroke_thin,
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExamSectionTitleHeader(section: section),
          SizedBox(height: 8.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.questions.length,
            itemBuilder: (context, qIndex) {
              return QuestionItem(
                question: section.questions[qIndex],
                onAnswerSelected: (option) => onAnswerChanged(qIndex, option),
              );
            },
          ),
        ],
      ),
    );
  }
}
