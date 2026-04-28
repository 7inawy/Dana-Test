import '../../../../core/utils/display_name_utils.dart';

class ParentProfileModel {
  final String id;
  final String parentName;
  final String phone;
  final String email;
  final String government;
  final String address;
  final String? profileImageUrl;
  final List<ParentChildModel> children;

  ParentProfileModel({
    required this.id,
    required this.parentName,
    required this.phone,
    this.email = '',
    this.government = '',
    this.address = '',
    this.profileImageUrl,
    required this.children,
  });

  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    final childrenJson = (json['children'] as List?) ?? const [];
    final rawImg = json['profileImage']?.toString();
    return ParentProfileModel(
      id: json['_id']?.toString() ?? '',
      parentName: DisplayNameUtils.dedupeRepeatedPhrase(
        json['parentName']?.toString() ?? '',
      ),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      government: json['government']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      profileImageUrl:
          (rawImg != null && rawImg.isNotEmpty && rawImg.startsWith('http'))
          ? rawImg
          : null,
      children: _childrenFromList(childrenJson),
    );
  }

  /// Backend may return full child objects or an array of child ObjectId strings.
  static List<ParentChildModel> _childrenFromList(List<dynamic> raw) {
    final out = <ParentChildModel>[];
    for (final c in raw) {
      if (c is String && c.isNotEmpty) {
        final tail = c.length > 4 ? c.substring(c.length - 4) : c;
        out.add(
          ParentChildModel(
            id: c,
            childName: 'طفل ···$tail',
            gender: 'male',
            birthDate: null,
            profileImageUrl: null,
          ),
        );
      } else if (c is Map) {
        out.add(ParentChildModel.fromJson(c.cast<String, dynamic>()));
      }
    }
    return out;
  }
}

class ParentChildModel {
  final String id;
  final String childName;
  final String gender;
  final DateTime? birthDate;
  final String? profileImageUrl;

  ParentChildModel({
    required this.id,
    required this.childName,
    required this.gender,
    required this.birthDate,
    this.profileImageUrl,
  });

  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    final rawBirth = json['birthDate']?.toString();
    DateTime? parsed;
    if (rawBirth != null && rawBirth.isNotEmpty) {
      parsed = DateTime.tryParse(rawBirth);
    }
    final rawImg = json['profileImage']?.toString();
    return ParentChildModel(
      id: json['_id']?.toString() ?? '',
      childName: DisplayNameUtils.dedupeRepeatedPhrase(
        json['childName']?.toString() ?? '',
      ),
      gender: json['gender']?.toString() ?? '',
      birthDate: parsed,
      profileImageUrl:
          (rawImg != null && rawImg.isNotEmpty && rawImg.startsWith('http'))
          ? rawImg
          : null,
    );
  }
}
