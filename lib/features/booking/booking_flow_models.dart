import 'package:flutter/material.dart';

import '../home/data/models/public_doctor_model.dart';

/// Passed into [AppRoutes.doctorTime] when starting booking from a doctor card.
class BookingDoctorArgs {
  const BookingDoctorArgs({
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.locationLine,
    required this.imageUrl,
    required this.detectionPrice,
    this.availableDates = const [],
    this.availableTimes = const [],
    this.timesByDate = const {},
    this.bookedTimesByDate = const {},
    this.ratingAverage = 0,
    this.ratingQuantity = 0,
    this.experienceYears = 0,
  });

  final String doctorId;
  final String doctorName;
  final String specialty;
  final String locationLine;
  final String imageUrl;
  final double detectionPrice;
  final List<String> availableDates;
  final List<String> availableTimes;
  /// Per-date offered time slots (API `HH:mm` strings).
  ///
  /// Preferred over [availableDates]/[availableTimes] when present.
  final Map<String, List<String>> timesByDate;

  /// Per-date booked time slots (subset of [timesByDate]).
  ///
  /// Dates that are fully booked should have `bookedTimes.length == times.length`.
  final Map<String, Set<String>> bookedTimesByDate;
  final double ratingAverage;
  final int ratingQuantity;
  final int experienceYears;

  static String dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  factory BookingDoctorArgs.fromPublicDoctor(PublicDoctorModel d) {
    return BookingDoctorArgs(
      doctorId: d.id,
      doctorName: d.doctorName,
      specialty: d.specialty,
      locationLine: d.locationLine,
      imageUrl: d.cardImageSrc,
      detectionPrice: d.detectionPrice,
      availableDates: d.availableDates,
      availableTimes: d.availableTimes,
      ratingAverage: d.ratingAverage,
      ratingQuantity: d.ratingQuantity,
      experienceYears: d.experienceYears,
    );
  }
}

/// Carries booking context through payment screens until [BookingRepo.createBooking].
class BookingDraft {
  static const Object _noChange = Object();

  const BookingDraft({
    required this.doctor,
    required this.dateIso,
    required this.timeHm,
    this.childId,
    this.childName,
    this.childYears,
    this.paymentMethod,
    this.notes,
    this.visitStatus = 'examination',
  });

  final BookingDoctorArgs doctor;
  final String dateIso;
  final String timeHm;
  final String? childId;
  final String? childName;
  final int? childYears;
  final String? paymentMethod;
  final String? notes;
  final String visitStatus;

  bool get hasSlot => dateIso.isNotEmpty && timeHm.isNotEmpty;

  bool get canSubmit =>
      doctor.doctorId.isNotEmpty &&
      hasSlot &&
      (childId != null && childId!.isNotEmpty) &&
      (paymentMethod != null && paymentMethod!.isNotEmpty);

  BookingDraft copyWith({
    String? childId,
    String? childName,
    int? childYears,
    String? paymentMethod,
    Object? notes = _noChange,
  }) {
    return BookingDraft(
      doctor: doctor,
      dateIso: dateIso,
      timeHm: timeHm,
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      childYears: childYears ?? this.childYears,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: identical(notes, _noChange) ? this.notes : notes as String?,
      visitStatus: visitStatus,
    );
  }

  static String timeToApi(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  /// Backend lists like `10:00,11:00,12:00,01:00` where afternoon hours are 01–11.
  static List<TimeOfDay> parseTimeStrings(List<String> raw) {
    if (raw.isEmpty) return const [];
    final out = <TimeOfDay>[];
    var seenNoon = false;
    for (final s in raw) {
      final parts = s.trim().split(':');
      if (parts.length < 2) continue;
      final h0 = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      var h = h0;
      if (h == 12) {
        seenNoon = true;
        out.add(TimeOfDay(hour: 12, minute: m));
        continue;
      }
      if (seenNoon && h >= 1 && h <= 11) {
        h += 12;
      }
      out.add(TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59)));
    }
    return out;
  }
}
