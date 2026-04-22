import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';

class QuestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const QuestionChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primary_50_light,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: AppColors.border_button_outlined_light,
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF000000),
            height: 1.36,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
