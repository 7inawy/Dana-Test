import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';
import 'package:dana/features/Appointments/presentation/appointment_rebook_args.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_row.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_month_navigator.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_data.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_grid.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RebookCancelledBottomSheet extends StatefulWidget {
  const RebookCancelledBottomSheet({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  State<RebookCancelledBottomSheet> createState() =>
      _RebookCancelledBottomSheetState();
}

class _RebookCancelledBottomSheetState
    extends State<RebookCancelledBottomSheet> {
  int _selectedTimeIndex = -1;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;

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

  void _onConfirm(BuildContext context) {
    final args = bookingDoctorArgsFromAppointment(widget.appointment);
    if (args == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر بدء الحجز: بيانات الطبيب غير مكتملة.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_selectedDate == null || _selectedTimeIndex < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectAppointment)),
      );
      return;
    }
    final dateIso = BookingDoctorArgs.dateKey(_selectedDate!);
    final t = AppointmentTimeData.availableTimes[_selectedTimeIndex];
    final timeHm = BookingDraft.timeToApi(t);
    final draft = BookingDraft(doctor: args, dateIso: dateIso, timeHm: timeHm);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(AppRoutes.paymentMethod, arguments: draft);
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
              title: context.l10n.changeAppointmentTitle,
              subtitle: context.l10n.changeAppointmentDesc,
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
              text: context.l10n.selectNewAppointment,
              onTap: () => _onConfirm(context),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
