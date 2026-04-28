import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDoctorInfo extends StatelessWidget {
  final Appointment appointment;
  final bool isDark;

  const AppointmentDoctorInfo({
    super.key,
    required this.appointment,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = appointment.image.startsWith('http');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: isNetworkImage
              ? Image.network(
                  appointment.image,
                  width: 67.w,
                  height: 67.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/Images/appointment/doctor_image.png',
                    width: 67.w,
                    height: 67.w,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  appointment.image,
                  width: 67.w,
                  height: 67.w,
                  fit: BoxFit.cover,
                ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  appointment.doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.semibold16TextHeading(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  appointment.specialty.isNotEmpty
                      ? appointment.specialty
                      : '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16.r,
                      color: isDark
                          ? AppColors.icon_onLight_dark
                          : AppColors.icon_onLight_light,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        appointment.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.regular12TextBody(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
