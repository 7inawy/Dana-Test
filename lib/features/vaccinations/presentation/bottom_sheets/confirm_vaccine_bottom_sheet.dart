import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmVaccineBottomSheet extends StatelessWidget {
  const ConfirmVaccineBottomSheet({
    super.key,
    required this.firstText,
    required this.firstTextStyle,
    required this.secondText,
    required this.photoSrc,
    required this.buttonText,
    this.extraWidgets,
    this.onConfirm,
  });

  final String firstText;
  final TextStyle firstTextStyle;
  final String secondText;
  final String photoSrc;
  final String buttonText;
  final Widget? extraWidgets;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: HomeIndicator()),
            SizedBox(height: 20.h),

            Center(child: SvgPicture.asset(photoSrc, height: 200.h)),

            SizedBox(height: 23.h),
            Text(firstText, style: firstTextStyle),

            SizedBox(height: 8.h),
            Text(
              secondText,
              style: AppTextStyle.medium12TextBody(context),
              textAlign: TextAlign.center,
            ),

            if (extraWidgets != null) extraWidgets!,

            SizedBox(height: 40.h),
            CustomButton(
              text: buttonText,
              textStyle: AppTextStyle.semibold16TextButton(context),
              onTap: () {
                onConfirm?.call();
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
