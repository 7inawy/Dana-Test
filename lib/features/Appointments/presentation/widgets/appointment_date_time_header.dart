import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/date_formatter.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentDateTimeHeader extends StatelessWidget {
  final Appointment appointment;
  final bool isDark;

  const AppointmentDateTimeHeader({
    super.key,
    required this.appointment,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = appointment.status == Status.cancelled;

    final color = isCancelled
        ? (isDark
              ? AppColors.error_default_dark
              : AppColors.error_default_light)
        : (isDark
              ? AppColors.primary_default_dark
              : AppColors.primary_default_light);

    final bgColor = isCancelled
        ? (isDark ? AppColors.error_subtle_dark : AppColors.error_subtle_light)
        : (isDark ? AppColors.primary_50_dark : AppColors.primary_50_light);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: color, width: AppRadius.stroke_thin),
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/Icons/calendar_icon.svg',
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? AppColors.icon_onLight_dark
                        : AppColors.icon_onLight_light,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  formatDate(context, appointment.date),
                  style: AppTextStyle.medium12TextHeading(context),
                ),
              ],
            ),
          ),
          Container(height: 23.h, width: 1.w, color: color),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/Icons/appointments/clock_icon.svg',
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? AppColors.icon_onLight_dark
                        : AppColors.icon_onLight_light,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  formatTime(
                    context,
                    appointment.startTime,
                    appointment.endTime,
                  ),
                  style: AppTextStyle.medium12TextHeading(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
