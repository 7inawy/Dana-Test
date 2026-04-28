import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, this.title, this.description});

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.w),
            child: SizedBox(
              child: Image.asset(
                'assets/Images/appointment/empty_appointment.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            title ?? 'لا توجد حجوزات حالياً',
            style: AppTextStyle.semibold16TextHeading(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            description ??
                'لم يتم تسجيل أي استشارات لطفلك بعد. نحن هنا دائمًا لتقديم الدعم، ومستعدون لمساعدتك في أي وقت للاطمئنان عليه.',
            style: AppTextStyle.medium12TextBody(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
