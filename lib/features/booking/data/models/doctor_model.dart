class Doctor {
  final String id;
  final String name;
  final int price;
  final String? profileImage;
  final String specialty;
  final String city;
  final String address;

  Doctor({
    required this.id,
    required this.name,
    required this.price,
    this.profileImage,
    this.specialty = '',
    this.city = '',
    this.address = '',
  });

  Doctor copyWith({
    String? id,
    String? name,
    int? price,
    String? profileImage,
    String? specialty,
    String? city,
    String? address,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      profileImage: profileImage ?? this.profileImage,
      specialty: specialty ?? this.specialty,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }

  String get locationLine {
    final parts = <String>[city, address].where((e) => e.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  factory Doctor.fromJson(dynamic json) {
    if (json is String) {
      return Doctor(id: json, name: '', price: 0);
    }
    // API decoding commonly produces `Map<dynamic, dynamic>` for nested objects.
    if (json is Map) {
      final map = json.cast<String, dynamic>();
      final name =
          map['doctorName']?.toString() ??
          map['name']?.toString() ??
          map['fullName']?.toString() ??
          '';
      final rawImg = map['profileImage']?.toString();
      return Doctor(
        id: map['_id']?.toString() ?? '',
        name: name,
        price: int.tryParse(map['detectionPrice']?.toString() ?? '') ?? 0,
        profileImage:
            (rawImg != null && rawImg.trim().isNotEmpty) ? rawImg : null,
        specialty: map['specialty']?.toString() ?? '',
        city: map['city']?.toString() ?? '',
        address: map['address']?.toString() ?? '',
      );
    }
    return Doctor(id: '', name: '', price: 0);
  }
}
