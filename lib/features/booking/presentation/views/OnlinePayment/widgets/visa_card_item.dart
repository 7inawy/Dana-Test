import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisaCardItem extends StatelessWidget {
  final int index;
  final Map<String, String> visa;
  final int? selectedVisa;
  final bool isDark;
  final VoidCallback onTap;

  const VisaCardItem({
    super.key,
    required this.index,
    required this.visa,
    required this.selectedVisa,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: selectedVisa == index
              ? (isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light)
              : (isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light),
          border: Border.all(
            color: selectedVisa == index
                ? (isDark
                      ? AppColors.primary_300_dark
                      : AppColors.primary_300_light)
                : (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light),
            width: 0.8.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  width: 32.w,
                  height: 20.h,
                  'assets/Images/logos_mastercard.png',
                ),
                SizedBox(width: 8.w),
                Text(
                  "**** **** **** ${visa['last4']}",
                  style: AppTextStyle.bold12TextBody(context),
                ),
              ],
            ),
            Text(
              visa['expiry'] ?? '',
              style: AppTextStyle.semibold12TextBody(context),
            ),
          ],
        ),
      ),
    );
  }
}
