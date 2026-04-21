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
