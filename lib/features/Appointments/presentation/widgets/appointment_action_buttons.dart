import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/appointment_rebook_args.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/change_appointment_bottom_sheet.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/rate_doctor_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentActionButtons extends StatelessWidget {
  final Appointment appointment;
  final bool isDark;
  final VoidCallback? onCancel;

  const AppointmentActionButtons({
    super.key,
    required this.appointment,
    required this.isDark,
    this.onCancel,
  });

  void _showSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => child,
    );
  }

  void _openRebookFlow(BuildContext context, Appointment appointment) {
    final args = bookingDoctorArgsFromAppointment(appointment);
    if (args == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر بدء الحجز: بيانات الطبيب غير مكتملة.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pushNamed(context, AppRoutes.doctorTime, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    switch (appointment.status) {
      case Status.upcoming:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                borderRadius: AppRadius.radius_md,
                height: 36.h,
                text: context.l10n.changeAppointment,
                onTap: () => _showSheet(
                  context,
                  ChangeAppointmentBottomSheet(appointment: appointment),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                color: Colors.transparent,
                borderRadius: AppRadius.radius_md,
                borderColor: isDark
                    ? AppColors.border_button_outlined_dark
                    : AppColors.border_button_outlined_light,
                height: 36.h,
                text: context.l10n.cancelAppointment,
                textStyle: AppTextStyle.semibold16TextButtonOutlined(context),
                onTap: () => onCancel?.call(),
              ),
            ),
          ],
        );

      case Status.completed:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                borderRadius: AppRadius.radius_md,
                height: 36.h,
                text: context.l10n.rebook,
                onTap: () => _openRebookFlow(context, appointment),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                color: Colors.transparent,
                borderRadius: AppRadius.radius_md,
                borderColor: isDark
                    ? AppColors.border_button_outlined_dark
                    : AppColors.border_button_outlined_light,
                height: 36.h,
                text: context.l10n.rateDoctor,
                textStyle: AppTextStyle.semibold16TextButtonOutlined(context),
                onTap: () => _showSheet(
                  context,
                  RateDoctorBottomSheet(bookingId: appointment.bookingId),
                ),
              ),
            ),
          ],
        );

      case Status.cancelled:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                borderRadius: AppRadius.radius_md,
                height: 36.h,
                text: context.l10n.rebook,
                onTap: () => _openRebookFlow(context, appointment),
              ),
            ),
          ],
        );
    }
  }
}
