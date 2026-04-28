import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_row.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_month_navigator.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_grid.dart';
import 'package:dana/features/Appointments/logic/appointment_controller.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';

class ChangeAppointmentBottomSheet extends StatefulWidget {
  final Appointment appointment;

  const ChangeAppointmentBottomSheet({super.key, required this.appointment});

  @override
  State<ChangeAppointmentBottomSheet> createState() =>
      _ChangeAppointmentBottomSheetState();
}

class _ChangeAppointmentBottomSheetState
    extends State<ChangeAppointmentBottomSheet> {
  bool _submitting = false;
  late final AppointmentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppointmentController();
    final doctorId = widget.appointment.doctorId;
    if (doctorId != null && doctorId.isNotEmpty) {
      _controller.applyBookingDoctor(
        BookingDoctorArgs(
          doctorId: doctorId,
          doctorName: widget.appointment.doctorNamePlain.isNotEmpty
              ? widget.appointment.doctorNamePlain
              : widget.appointment.doctorName,
          specialty: widget.appointment.specialty,
          locationLine: widget.appointment.address,
          imageUrl: widget.appointment.image,
          detectionPrice: widget.appointment.detectionPrice,
          availableDates: const [],
          availableTimes: const [],
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.refreshDoctorAvailability();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onConfirm(BuildContext context) async {
    final bookingId = widget.appointment.bookingId;
    final doctorId = widget.appointment.doctorId;
    if (bookingId == null || bookingId.isEmpty) return;
    if (doctorId == null || doctorId.isEmpty) return;
    final date = _controller.selectedDate;
    final timeIndex = _controller.selectedTimeIndex;
    if (date == null ||
        timeIndex < 0 ||
        timeIndex >= _controller.timeSlots.length) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.selectAppointment),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final me = await sl<ParentProfileRepository>().getMe();
      final picked = _controller.timeSlots[timeIndex];
      final time = BookingDraft.timeToApi(picked);
      final dateIso = BookingDoctorArgs.dateKey(date);

      final err = await context.read<BookingCubit>().changeAppointment(
        bookingId: bookingId,
        doctorId: doctorId,
        parentId: me.id,
        date: dateIso,
        time: time,
      );
      if (!context.mounted) return;
      if (err == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.bookingConfirmed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<AppointmentController>(
        builder: (context, controller, _) {
          // Keep the UI stable even if availability isn't loaded yet.
          final fallbackDates = AppointmentCalendarLogic.getMonthDays(
            controller.currentMonth,
            DateTime.now(),
          );
          final dates = controller.dateList.isNotEmpty ? controller.dateList : fallbackDates;
          return Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: HomeIndicator()),
                  SizedBox(height: 20.h),
                  CustomScreenHeader(
                    title: context.l10n.needBetterTimeTitle,
                    subtitle: context.l10n.needBetterTimeDesc,
                  ),
                  SizedBox(height: 24.h),
                  AppointmentMonthNavigator(
                    currentMonth: controller.currentMonth,
                    onPrevious: controller.goToPreviousMonth,
                    onNext: controller.goToNextMonth,
                  ),
                  SizedBox(height: 12.h),
                  AppointmentDateRow(
                    dates: dates,
                    selectedDate: controller.selectedDate,
                    isDisabled: controller.isDateFullyBooked,
                    onSelected: controller.selectDate,
                  ),
                  SizedBox(height: 24.h),
                  AppointmentTimeGrid(
                    times: controller.timeSlots,
                    selectedIndex: controller.selectedTimeIndex,
                    isBooked: controller.isTimeBooked,
                    onSelected: controller.selectTime,
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    text: _submitting ? '…' : context.l10n.confirmNewAppointment,
                    onTap: () {
                      if (_submitting) return;
                      _onConfirm(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
