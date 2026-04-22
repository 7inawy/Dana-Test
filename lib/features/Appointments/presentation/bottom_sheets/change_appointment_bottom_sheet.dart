import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_row.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_month_navigator.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_data.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_grid.dart';
import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int _selectedTimeIndex = -1;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;
  bool _submitting = false;

  List<DateTime> get _dateList =>
      AppointmentCalendarLogic.getMonthDays(_currentMonth, DateTime.now());

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _selectedDate = null;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _selectedDate = null;
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _selectTime(int index) {
    setState(() => _selectedTimeIndex = index);
  }

  Future<void> _onConfirm(BuildContext context) async {
    final bookingId = widget.appointment.bookingId;
    final doctorId = widget.appointment.doctorId;
    if (bookingId == null || bookingId.isEmpty) return;
    if (doctorId == null || doctorId.isEmpty) return;
    if (_selectedDate == null ||
        _selectedTimeIndex < 0 ||
        _selectedTimeIndex >= AppointmentTimeData.availableTimes.length) {
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
      final picked = AppointmentTimeData.availableTimes[_selectedTimeIndex];
      final time =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      final date =
          '${_selectedDate!.year.toString().padLeft(4, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      final err = await context.read<BookingCubit>().changeAppointment(
        bookingId: bookingId,
        doctorId: doctorId,
        parentId: me.id,
        date: date,
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
              currentMonth: _currentMonth,
              onPrevious: _goToPreviousMonth,
              onNext: _goToNextMonth,
            ),
            SizedBox(height: 12.h),

            AppointmentDateRow(
              dates: _dateList,
              selectedDate: _selectedDate,
              onSelected: _selectDate,
            ),
            SizedBox(height: 24.h),

            AppointmentTimeGrid(
              times: AppointmentTimeData.availableTimes,
              selectedIndex: _selectedTimeIndex,
              onSelected: _selectTime,
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
  }
}
