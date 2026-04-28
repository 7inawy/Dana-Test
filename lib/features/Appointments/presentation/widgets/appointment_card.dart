import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_time_header.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_doctor_info.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onCancel;

  const AppointmentCard({super.key, required this.appointment, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomFrame(
        child: Column(
          children: [
            AppointmentDateTimeHeader(appointment: appointment, isDark: isDark),
            AppointmentDoctorInfo(appointment: appointment, isDark: isDark),
            Divider(
              height: 24.h,
              thickness: 1.h,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
            AppointmentActionButtons(
              appointment: appointment,
              isDark: isDark,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
