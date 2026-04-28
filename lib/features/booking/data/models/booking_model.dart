import 'package:dana/features/booking/data/models/child_model.dart';
import 'package:dana/features/booking/data/models/doctor_model.dart';

class Booking {
  final String id;
  final String date;
  final String time;
  final String status;
  final String paymentStatus;
  final Child child;
  final Doctor doctor;
  final String parentId;

  /// Session fee from the booking row (API `detectionPrice`); used when doctor is only an id string.
  final int detectionPrice;

  /// Backend flag for finished consultation (`myAppointment` list).
  final bool isCompletedConsultation;

  /// e.g. `examination`, `consultation`
  final String visitStatus;

  /// Parent-submitted rating for this booking, when returned by the API.
  final double? rating;

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentStatus,
    required this.child,
    required this.doctor,
    required this.parentId,
    this.detectionPrice = 0,
    this.isCompletedConsultation = false,
    this.visitStatus = '',
    this.rating,
  });

  Booking copyWith({
    String? id,
    String? date,
    String? time,
    String? status,
    String? paymentStatus,
    Child? child,
    Doctor? doctor,
    String? parentId,
    int? detectionPrice,
    bool? isCompletedConsultation,
    String? visitStatus,
    double? rating,
  }) {
    return Booking(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      child: child ?? this.child,
      doctor: doctor ?? this.doctor,
      parentId: parentId ?? this.parentId,
      detectionPrice: detectionPrice ?? this.detectionPrice,
      isCompletedConsultation:
          isCompletedConsultation ?? this.isCompletedConsultation,
      visitStatus: visitStatus ?? this.visitStatus,
      rating: rating ?? this.rating,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final parentRaw = json['parentId'];
    final rawPrice = json['detectionPrice'];
    final price = rawPrice is num
        ? rawPrice.toInt()
        : int.tryParse(rawPrice?.toString() ?? '') ?? 0;
    final completedRaw = json['isCompletedConsultation'];
    final completed = completedRaw == true ||
        completedRaw?.toString().toLowerCase() == 'true';
    final rawRating = json['rating'];
    final double? parsedRating = rawRating == null
        ? null
        : (rawRating is num ? rawRating.toDouble() : double.tryParse(rawRating.toString()));
    return Booking(
      id: json['_id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      child: Child.fromJson(json['childId']),
      doctor: Doctor.fromJson(json['doctorId']),
      parentId: parentRaw is Map
          ? (parentRaw['_id']?.toString() ?? '')
          : parentRaw?.toString() ?? '',
      detectionPrice: price,
      isCompletedConsultation: completed,
      visitStatus: json['visitStatus']?.toString() ?? '',
      rating: parsedRating,
    );
  }
}
