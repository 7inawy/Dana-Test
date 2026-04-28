import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/repo/auth_repository.dart';
import 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final AuthRepository _repo;

  GoogleAuthCubit(this._repo) : super(const GoogleAuthInitial());

  String? _extractUrl(dynamic payload) {
    if (payload == null) return null;
    if (payload is String) return payload.trim();
    if (payload is Map) {
      final candidates = [
        payload['redirectUrl'],
        payload['url'],
        payload['authUrl'],
        payload['redirect'],
      ];
      for (final c in candidates) {
        final s = c?.toString().trim();
        if (s != null && s.isNotEmpty) return s;
      }
    }
    return null;
  }

  Future<void> start() async {
    emit(const GoogleAuthLoading());

    final res = await _repo.googleSignIn();
    res.fold(
      (Failure f) => emit(GoogleAuthFailure(message: f.message)),
      (data) {
        final url = _extractUrl(data);
        if (url == null || url.isEmpty) {
          emit(const GoogleAuthFailure(message: 'Google URL not returned'));
          return;
        }
        emit(GoogleAuthLaunchUrl(url: url));
      },
    );
  }

  Future<void> complete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  }) async {
    emit(const GoogleAuthCompleteLoading());
    final res = await _repo.googleComplete(
      requestId: requestId,
      phone: phone,
      password: password,
      government: government,
      address: address,
      children: children,
    );
    res.fold(
      (f) => emit(GoogleAuthFailure(message: f.message)),
      (user) => emit(GoogleAuthSuccess(user: user)),
    );
  }
}

