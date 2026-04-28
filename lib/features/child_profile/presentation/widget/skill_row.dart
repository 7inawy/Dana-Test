import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/child_profile/presentation/widget/custom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkillRow extends StatelessWidget {
  final String label;
  final int value;

  const SkillRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.regular12TextBody(context)),
            Text('$value%', style: AppTextStyle.semibold12Primary(context)),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 8.h),
          child: CustomProgressBar(value: value),
        ),
      ],
    );
  }
}
