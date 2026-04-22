class Doctor {
  final String id;
  final String name;
  final int price;
  final String? profileImage;

  Doctor({
    required this.id,
    required this.name,
    required this.price,
    this.profileImage,
  });

  factory Doctor.fromJson(dynamic json) {
    if (json is String) {
      return Doctor(id: json, name: '', price: 0);
    }
    if (json is Map<String, dynamic>) {
      return Doctor(
        id: json['_id']?.toString() ?? '',
        name: json['doctorName']?.toString() ?? '',
        price: int.tryParse(json['detectionPrice']?.toString() ?? '') ?? 0,
        profileImage: json['profileImage']?.toString(),
      );
    }
    return Doctor(id: '', name: '', price: 0);
  }
}
