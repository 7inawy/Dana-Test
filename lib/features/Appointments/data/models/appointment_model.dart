import 'package:flutter/material.dart';

enum Status { upcoming, completed, cancelled }

class Appointment {
  final String? bookingId;
  final String? childId;
  final String? doctorId;

  /// Display name (may include localized "Dr" prefix).
  final String doctorName;

  /// Plain doctor name for API / rebook navigation.
  final String doctorNamePlain;
  final String specialty;
  final double detectionPrice;
  final String image;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String address;
  final Status status;

  Appointment({
    this.bookingId,
    this.childId,
    this.doctorId,
    required this.doctorName,
    this.doctorNamePlain = '',
    this.specialty = '',
    this.detectionPrice = 0,
    required this.image,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.status,
  });
}
