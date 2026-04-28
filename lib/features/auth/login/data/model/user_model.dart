import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.token,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      role: json['role']?.toString() ?? 'parent',
    );
  }

  factory UserModel.fromToken({required String token}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw const FormatException('Invalid JWT');

      String payload = parts[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      final decoded = jsonDecode(utf8.decode(base64Decode(payload)));

      final id =
          decoded['sub']?.toString() ??
          decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
              ?.toString() ??
          '';

      final name =
          decoded['name']?.toString() ??
          decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
              ?.toString() ??
          'مستخدم';

      // ✅ phone بييجي من الـ JWT مش من الـ request
      final phone = decoded['phone']?.toString() ?? '';

      final role =
          decoded['role']?.toString() ??
          decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
              ?.toString() ??
          'parent';

      return UserModel(
        id: id,
        name: name,
        phone: phone,
        token: token,
        role: role,
      );
    } catch (_) {
      return UserModel(
        id: '',
        name: 'مستخدم',
        phone: '',
        token: token,
        role: 'parent',
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'token': token,
    'role': role,
  };
}
