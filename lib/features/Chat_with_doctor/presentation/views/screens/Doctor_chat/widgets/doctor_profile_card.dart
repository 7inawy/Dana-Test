import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/doctor_Info.dart';
import 'package:dana/features/Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/profile_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';
import 'large_Avatar.dart';

class DoctorProfileCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfileCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LargeAvatar(imageUrl: doctor.imageUrl),
          SizedBox(height: 16.h),

          DoctorInfo(doctor: doctor),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isRtl) ...[
                Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.icon_onLight_dark
                      : AppColors.icon_onLight_light,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                doctor.location,
                style: AppTextStyle.regular12TextBody(
                  context,
                ).copyWith(height: 1.35),
              ),
              if (isRtl) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.icon_onLight_dark
                      : AppColors.icon_onLight_light,
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          const ProfileButton(),
        ],
      ),
    );
  }
}
