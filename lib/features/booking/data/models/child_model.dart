class Child {
  final String id;
  final String name;
  final String birthDate;

  Child({required this.id, required this.name, required this.birthDate});

  factory Child.fromJson(dynamic json) {
    if (json is String) {
      return Child(id: json, name: '', birthDate: '');
    }
    // API decoding commonly produces `Map<dynamic, dynamic>` for nested objects.
    if (json is Map) {
      final map = json.cast<String, dynamic>();
      return Child(
        id: map['_id']?.toString() ?? '',
        name: map['childName']?.toString() ?? '',
        birthDate: map['birthDate']?.toString() ?? '',
      );
    }
    return Child(id: '', name: '', birthDate: '');
  }
}
