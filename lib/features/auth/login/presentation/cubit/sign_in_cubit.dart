import 'package:dana/core/utils/parent_phone_utils.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_in_state.dart';
import 'package:dana/features/auth/login/domain/usecases/pre_sign_in_usecase.dart';
import 'package:dana/features/auth/login/domain/usecases/verify_sign_in_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final PreSignInUseCase preSignInUseCase;
  final VerifySignInUseCase verifySignInUseCase;

  SignInCubit({
    required this.preSignInUseCase,
    required this.verifySignInUseCase,
  }) : super(const SignInInitial());

  // ── الـ fields بتخزن قيم الـ form ─────────────────────────────────────────
  String _phone = '';
  String _password = '';

  void updatePhone(String value) => _phone = value;
  void updatePassword(String value) => _password = value;

  // ── Step 1: إرسال رقم الهاتف وكلمة المرور ────────────────────────────────
  Future<void> preSignIn() async {
    if (_phone.isEmpty || _password.isEmpty) {
      emit(
        const SignInFailure(message: 'من فضلك ادخل رقم الهاتف وكلمة المرور'),
      );
      return;
    }

    final apiPhone = ParentPhoneUtils.normalizeForApi(_phone);
    _phone = apiPhone;

    emit(const SignInLoading());
    final result = await preSignInUseCase(
      PreSignInParams(phone: apiPhone, password: _password),
    );
    result.fold(
      (f) => emit(SignInFailure(message: f.message)),
      (_) => emit(SignInOtpSent(phone: apiPhone)),
    );
  }

  // ── Step 2: تأكيد OTP والحصول على التوكن ─────────────────────────────────
  Future<void> verifySignIn({required String otp}) async {
    emit(const SignInLoading());
    final result = await verifySignInUseCase(
      VerifySignInParams(
        phone: ParentPhoneUtils.normalizeForApi(_phone),
        otp: otp,
      ),
    );
    result.fold(
      (f) => emit(SignInFailure(message: f.message)),
      (user) => emit(SignInSuccess(user: user)),
    );
  }
}
