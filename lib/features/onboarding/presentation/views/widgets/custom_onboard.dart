import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/Custom_indicator.dart';
import 'package:dana/features/onboarding/data/model/onboard_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CustomOnboard extends StatelessWidget {
  final OnboardModel onboardModel;
  final int index;
  final PageController controller;

  const CustomOnboard({
    super.key,
    required this.onboardModel,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 74.5.h),
        SizedBox(
          width: 304.w,
          height: 267.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -40,
                bottom: 1,
                child: Image.asset(
                  onboardModel.mainImage,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        CustomIndicatorRow(
          currentIndex: index,
          itemCount: 3,
          activeWidth: 56,
          inactiveWidth: 24,
          height: 4,
          spacing: 5,
        ),
        SizedBox(height: 48.h),
        Text(
          onboardModel.headingText,
          textAlign: TextAlign.center,
          style: AppTextStyle.semibold24TextHeading(context),
        ),
        SizedBox(height: 24.h),
        Text(
          onboardModel.textLg,
          textAlign: TextAlign.center,
          style: AppTextStyle.medium16TextBody(context),
        ),
      ],
    );
  }
}
