import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogOutBottomSheet extends StatefulWidget {
  const LogOutBottomSheet({super.key});

  @override
  State<LogOutBottomSheet> createState() => _LogOutBottomSheetState();
}

class _LogOutBottomSheetState extends State<LogOutBottomSheet> {
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
            Center(
              child: SvgPicture.asset(
                'assets/Icons/profile/log_out_photo.svg',
                width: 250.w,
                height: 247.h,
              ),
            ),
            SizedBox(height: 23.h),
            Text(
              context.l10n.logoutTitle,
              style: AppTextStyle.semibold24ErrorDefault(context),
            ),
            SizedBox(height: 8.h),
            Text(
              context.l10n.loginDesc,
              style: AppTextStyle.medium16TextBody(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: context.l10n.stayButton,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomButton(
                    color: Colors.transparent,
                    borderWidth: 1.w,
                    borderColor: AppColors.error_default_light,
                    text: context.l10n.confirmLogoutButton,
                    textColor: AppColors.error_default_light,
                    onTap: () async {
                      await sl<AuthSession>().clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
