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

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentStatus,
    required this.child,
    required this.doctor,
    required this.parentId,
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
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final parentRaw = json['parentId'];
    return Booking(
      id: json['_id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      child: Child.fromJson(json['childId']),
      doctor: Doctor.fromJson(json['doctorId']),
      parentId: parentRaw is Map
          ? (parentRaw['_id']?.toString() ?? '')
          : parentRaw?.toString() ?? '',
    );
  }
}
