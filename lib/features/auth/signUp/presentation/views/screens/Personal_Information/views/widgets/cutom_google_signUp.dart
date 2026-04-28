import 'package:dana/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GoogleSignUpButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GoogleSignUpButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.h16, bottom: AppSizes.h26),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              'assets/Icons/google_icon.svg',
              width: 50.w,
              height: 50.h,
            ),
          ),
        ),
      ),
    );
  }
}
