import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final bool isDark;

  const ConfirmationBottomSheet({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 21.h, left: 24.w, right: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 134.w,
              height: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
              ),
            ),
            SizedBox(height: 28.h),
            Image.asset(
              width: 150.w,
              height: 150.h,
              'assets/Images/result page success motion design 1.png',
            ),
            Text(
              'تم تأكيد الحجز',
              style: AppTextStyle.bold20TextDisplay(context),
            ),
            Text(
              'استلمنا الدفع وتم تأكيد الحجز بنجاح. نتشرف بزيارتكم.',
              style: AppTextStyle.bold16TextBody(context),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'تم',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.appointments);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
