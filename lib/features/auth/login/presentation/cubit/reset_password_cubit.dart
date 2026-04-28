import 'package:dana/core/utils/parent_phone_utils.dart';
import 'package:dana/features/auth/login/presentation/cubit/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_password_otp_usecase.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;
  final VerifyPasswordOtpUseCase verifyPasswordOtpUseCase;

  ResetPasswordCubit({
    required this.resetPasswordUseCase,
    required this.verifyPasswordOtpUseCase,
  }) : super(const ResetPasswordInitial());

  /// Step 1 – إرسال رقم الهاتف لاستلام OTP
  Future<void> sendOtp({required String phone}) async {
    final apiPhone = ParentPhoneUtils.normalizeForApi(phone);
    emit(const ResetPasswordLoading());
    final result = await resetPasswordUseCase(apiPhone);
    if (isClosed) return;
    result.fold(
      (f) => emit(ResetPasswordFailure(message: f.message)),
      (_) => emit(ResetPasswordOtpSent(phone: apiPhone)),
    );
  }

  /// Step 2 – تأكيد OTP
  Future<void> verifyOtp({required String phone, required String otp}) async {
    final apiPhone = ParentPhoneUtils.normalizeForApi(phone);
    emit(const ResetPasswordLoading());
    final result = await verifyPasswordOtpUseCase(
      VerifyPasswordOtpParams(phone: apiPhone, otp: otp),
    );
    if (isClosed) return;
    result.fold(
      (f) => emit(ResetPasswordFailure(message: f.message)),
      (token) => emit(
        ResetPasswordOtpVerified(phone: apiPhone, otp: otp, token: token),
      ),
    );
  }
}
