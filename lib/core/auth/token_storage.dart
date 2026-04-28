import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kTokenKey = 'auth.jwt';

  final FlutterSecureStorage _storage;

  const TokenStorage(this._storage);

  Future<String?> readToken() => _storage.read(key: _kTokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _kTokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: _kTokenKey);
}
