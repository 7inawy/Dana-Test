import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_card.dart';
import 'package:dana/features/Appointments/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../booking/presentation/cubit/booking_cubit.dart';

class AppointmentsList extends StatefulWidget {
  final List<Appointment> appointments;
  final Status status;

  const AppointmentsList({
    super.key,
    required this.appointments,
    required this.status,
  });

  @override
  State<AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  Future<void> _confirmAndCancel(
    BuildContext context,
    Appointment appointment,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.cancelAppointment),
        content: const Text('سيتم إلغاء هذا الحجز. هل تريد المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.done),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final bookingId = appointment.bookingId;
    final cubit = context.read<BookingCubit>();
    final String? err;
    if (bookingId != null && bookingId.isNotEmpty) {
      err = await cubit.cancelBookingById(bookingId: bookingId);
    } else {
      final childId = appointment.childId;
      if (childId == null || childId.isEmpty) return;
      err = await cubit.cancelByChildId(childId: childId);
    }
    if (!context.mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.appointments
        .where((e) => e.status == widget.status)
        .toList();

    if (filtered.isEmpty) {
      return const EmptyStateWidget();
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          appointment: filtered[index],
          onCancel: () => _confirmAndCancel(context, filtered[index]),
        );
      },
    );
  }
}
