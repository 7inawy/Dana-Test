import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/appointment_rebook_args.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/change_appointment_bottom_sheet.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/rebook_cancelled_bottom_sheet.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/rebook_completed_bottom_sheet.dart';
import 'package:dana/features/Appointments/presentation/bottom_sheets/rate_doctor_bottom_sheet.dart';
import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final bookingCubit = context.read<BookingCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(value: bookingCubit, child: child),
    );
  }

  void _openRebookBottomSheet(BuildContext context, Appointment appointment) {
    // Ensure we can build a booking draft later (doctor data required).
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
    switch (appointment.status) {
      case Status.completed:
        _showSheet(context, RebookCompletedBottomSheet(appointment: appointment));
        return;
      case Status.cancelled:
        _showSheet(context, RebookCancelledBottomSheet(appointment: appointment));
        return;
      case Status.upcoming:
        // Upcoming doesn't use "rebook" here.
        return;
    }
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
        final rated = appointment.userRating;
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                borderRadius: AppRadius.radius_md,
                height: 36.h,
                text: context.l10n.rebook,
                onTap: () => _openRebookBottomSheet(context, appointment),
              ),
            ),
            if (rated != null) ...[
              SizedBox(width: 10.w),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 22.r, color: Colors.amber.shade700),
                      SizedBox(width: 4.w),
                      Text(
                        rated == rated.roundToDouble()
                            ? '${rated.toInt()}/5'
                            : '${rated.toStringAsFixed(1)}/5',
                        style: AppTextStyle.semibold16TextButtonOutlined(context),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
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
                    RateDoctorBottomSheet(appointment: appointment),
                  ),
                ),
              ),
            ],
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
                onTap: () => _openRebookBottomSheet(context, appointment),
              ),
            ),
          ],
        );
    }
  }
}
