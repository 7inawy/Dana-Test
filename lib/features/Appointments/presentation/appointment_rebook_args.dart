import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/booking/booking_flow_models.dart';

/// Builds [BookingDoctorArgs] for [AppRoutes.doctorTime] from an existing appointment.
BookingDoctorArgs? bookingDoctorArgsFromAppointment(Appointment a) {
  final id = a.doctorId;
  if (id == null || id.isEmpty) return null;
  final name = a.doctorNamePlain.isNotEmpty ? a.doctorNamePlain : a.doctorName;
  final spec = a.specialty.isNotEmpty ? a.specialty : 'طبيب';
  return BookingDoctorArgs(
    doctorId: id,
    doctorName: name,
    specialty: spec,
    locationLine: a.address,
    imageUrl: a.image,
    detectionPrice: a.detectionPrice,
    availableDates: const [],
    availableTimes: const [],
  );
}

/// Doctor row for rating sheet — same as rebook when possible, else fields from [Appointment].
BookingDoctorArgs ratingDoctorArgsFromAppointment(Appointment a) {
  final from = bookingDoctorArgsFromAppointment(a);
  if (from != null) return from;
  final name = a.doctorNamePlain.trim().isNotEmpty
      ? a.doctorNamePlain.trim()
      : a.doctorName.trim();
  return BookingDoctorArgs(
    doctorId: a.doctorId ?? '',
    doctorName: name,
    specialty: a.specialty,
    locationLine: a.address,
    imageUrl: a.image,
    detectionPrice: a.detectionPrice,
    availableDates: const [],
    availableTimes: const [],
  );
}
