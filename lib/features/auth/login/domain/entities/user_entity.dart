import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone; // الـ API الجديد phone-based
  final String token;
  final String role; // 'parent' | 'doctor' | 'admin'

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
    required this.role,
  });

  /// Display name with doctor prefix if applicable
  String get displayName {
    if (role.toLowerCase() == 'doctor') return 'د. $name';
    return name;
  }

  @override
  List<Object?> get props => [id, name, phone, token, role];
}
