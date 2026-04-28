import 'token_storage.dart';

class AuthSession {
  final TokenStorage _tokenStorage;

  const AuthSession(this._tokenStorage);

  Future<String?> token() => _tokenStorage.readToken();

  Future<bool> hasToken() async {
    final t = await _tokenStorage.readToken();
    return t != null && t.trim().isNotEmpty;
  }

  Future<void> setToken(String token) => _tokenStorage.writeToken(token);

  Future<void> clear() => _tokenStorage.clearToken();
}
