import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/change_password_usecase.dart';
import 'change_password_state.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
    : super(const ChangePasswordInitial());

  Future<void> changePassword({
    required String phone,
    required String password,
    required String token,
  }) async {
    emit(const ChangePasswordLoading());
    final result = await changePasswordUseCase(
      ChangePasswordParams(phone: phone, password: password, token: token),
    );
    result.fold(
      (f) => emit(ChangePasswordFailure(message: f.message)),
      (_) => emit(const ChangePasswordSuccess()),
    );
  }
}
