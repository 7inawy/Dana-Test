import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHeaderCard extends StatelessWidget {
  const PatientHeaderCard({
    super.key,
    required this.isDark,
    this.childName,
    this.childYears,
    this.visitLabel,
  });

  final bool isDark;
  final String? childName;
  final int? childYears;
  final String? visitLabel;

  @override
  Widget build(BuildContext context) {
    final visit = visitLabel ?? '(${context.l10n.visitTypeExam})';
    final name = childName ?? '—';
    final years = childYears ?? 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        border: BoxBorder.all(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  '$name ',
                  style: AppTextStyle.semibold20TextHeading(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(' $visit', style: AppTextStyle.bold12TextBody(context)),
            ],
          ),
          Text(
            '$years ${context.l10n.years}',
            style: AppTextStyle.bold12TextBody(context),
          ),
        ],
      ),
    );
  }
}
