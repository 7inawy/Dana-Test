import 'package:dana/features/Chat_bot/presentation/controller/data/model/message_model.dart';

/// Doctor row from `GET /v1/doctor` (list item or single object).
class PublicDoctorModel {
  const PublicDoctorModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.city,
    required this.address,
    this.profileImageUrl,
    this.ratingAverage = 0,
    this.ratingQuantity = 0,
    this.detectionPrice = 0,
    this.experienceYears = 0,
    this.availableDates = const [],
    this.availableTimes = const [],
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String city;
  final String address;
  final String? profileImageUrl;
  final double ratingAverage;
  final int ratingQuantity;
  final double detectionPrice;
  final int experienceYears;
  final List<String> availableDates;
  final List<String> availableTimes;

  static List<String> _stringList(dynamic v) {
    if (v is! List) return const [];
    return v.map((e) => e.toString()).toList();
  }

  factory PublicDoctorModel.fromJson(Map<String, dynamic> json) {
    final rawImg = json['profileImage']?.toString();
    final dates = _stringList(
      json['avilableDate'] ?? json['availableDate'] ?? json['availableDates'],
    );
    final times = _stringList(
      json['avilableTime'] ?? json['availableTime'] ?? json['availableTimes'],
    );
    return PublicDoctorModel(
      id: json['_id']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      profileImageUrl:
          (rawImg != null && rawImg.isNotEmpty && rawImg.startsWith('http'))
          ? rawImg
          : null,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingQuantity: (json['ratingQuantity'] as num?)?.toInt() ?? 0,
      detectionPrice: (json['detectionPrice'] as num?)?.toDouble() ?? 0,
      experienceYears:
          (json['expirtes'] as num?)?.toInt() ??
          (json['experienceYears'] as num?)?.toInt() ??
          (json['yearsOfExperience'] as num?)?.toInt() ??
          0,
      availableDates: dates,
      availableTimes: times,
    );
  }

  String get locationLine {
    final parts = <String>[city, address].where((e) => e.isNotEmpty).toList();
    return parts.join(', ');
  }

  /// Image for [DoctorCard]: network URL or local asset path.
  String get cardImageSrc =>
      profileImageUrl ?? 'assets/Images/home/doctor1.png';

  Doctor toChatDoctor() {
    final loc = locationLine.trim();
    return Doctor(
      id: id.isEmpty ? null : id,
      name: doctorName,
      specialty: specialty,
      location: loc.isEmpty ? ' ' : loc,
      imageUrl: profileImageUrl ?? 'assets/Images/home/doctor1.png',
    );
  }
}
