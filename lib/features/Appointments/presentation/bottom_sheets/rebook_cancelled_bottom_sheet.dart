import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/logic/appointment_controller.dart';
import 'package:dana/features/Appointments/presentation/appointment_rebook_args.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_row.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_month_navigator.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_grid.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  void _onConfirm(BuildContext context) {
    final controller = context.read<AppointmentController>();
    final draft = controller.buildDraftForPayment();
    if (draft == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectAppointment)),
      );
      return;
    }

    Navigator.pop(context);
    Navigator.of(context).pushNamed(AppRoutes.paymentMethod, arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
    final args = bookingDoctorArgsFromAppointment(widget.appointment);
    if (args == null) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Center(child: HomeIndicator()),
            SizedBox(height: 16),
            Text('تعذر بدء الحجز: بيانات الطبيب غير مكتملة.'),
            SizedBox(height: 16),
          ],
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) {
        final c = AppointmentController();
        c.applyBookingDoctor(args);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          c.refreshDoctorAvailability();
        });
        return c;
      },
      child: Consumer<AppointmentController>(
        builder: (context, controller, _) {
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
              currentMonth: controller.currentMonth,
              onPrevious: controller.goToPreviousMonth,
              onNext: controller.goToNextMonth,
            ),
            SizedBox(height: 12.h),

            AppointmentDateRow(
              dates: controller.dateList,
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
              text: context.l10n.selectNewAppointment,
              onTap: () => _onConfirm(context),
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
