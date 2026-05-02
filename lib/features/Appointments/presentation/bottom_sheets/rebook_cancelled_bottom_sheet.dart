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
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/errors/error_mapper.dart';
import 'package:dana/features/booking/data/repo/booking_repo.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
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
  bool _submitting = false;

  int _yearsOld(DateTime? birthDate) {
    if (birthDate == null) return 0;
    final n = DateTime.now();
    var y = n.year - birthDate.year;
    if (n.month < birthDate.month ||
        (n.month == birthDate.month && n.day < birthDate.day)) {
      y--;
    }
    return y < 0 ? 0 : y;
  }

  Future<void> _onConfirm(BuildContext context) async {
    if (_submitting) return;
    final controller = context.read<AppointmentController>();
    final slotDraft = controller.buildDraftForPayment();
    if (slotDraft == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectAppointment)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final me = await sl<ParentProfileRepository>().getMe();
      final bookingId = widget.appointment.bookingId;
      String? childId = widget.appointment.childId;
      String paymentMethod = 'on-visit';
      String? notes;

      if (bookingId != null && bookingId.isNotEmpty) {
        final b = await sl<BookingRepo>().getBookingById(bookingId: bookingId);
        if (b.child.id.isNotEmpty) childId = b.child.id;
        if (b.paymentMethod.trim().isNotEmpty) paymentMethod = b.paymentMethod.trim();
        final n = b.notes.trim();
        if (n.isNotEmpty) notes = n;
      }

      if (childId == null || childId.isEmpty) {
        throw Exception(context.l10n.bookingDraftIncomplete);
      }

      dynamic child;
      for (final c in me.children) {
        if (c.id == childId) {
          child = c;
          break;
        }
      }

      final childName = child?.childName;
      final childYears = _yearsOld(child?.birthDate);

      final draft = slotDraft.copyWith(
        childId: childId,
        childName: childName,
        childYears: childYears,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      if (!mounted) return;
      Navigator.pop(context);
      if (paymentMethod == 'visa') {
        Navigator.of(context).pushNamed(AppRoutes.onlinePaymentScreen, arguments: draft);
      } else {
        Navigator.of(context).pushNamed(AppRoutes.paymentSuccessScreen, arguments: draft);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localized(context, e))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = bookingDoctorArgsFromAppointment(widget.appointment);
    if (args == null) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 24.w,
          end: 24.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: HomeIndicator()),
            const SizedBox(height: 16),
            Text(context.l10n.bookingStartFailedMissingDoctorData),
            const SizedBox(height: 16),
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
      padding: EdgeInsetsDirectional.only(
        start: 24.w,
        end: 24.w,
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
