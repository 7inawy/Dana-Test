import 'package:dana/core/utils/parent_phone_utils.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/usecases/add_sign_up_password_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/pre_sign_up_usecase.dart';
import '../../domain/usecases/verify_sign_up_usecase.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final PreSignUpUseCase preSignUpUseCase;
  final VerifySignUpUseCase verifySignUpUseCase;
  final AddSignUpPasswordUseCase addSignUpPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  SignUpCubit({
    required this.preSignUpUseCase,
    required this.verifySignUpUseCase,
    required this.addSignUpPasswordUseCase,
    required this.changePasswordUseCase,
  }) : super(const SignUpInitial());

  // ── Step 1: Personal Information ──────────────────────────────────────────
  String _parentName = '';
  String _government = '';
  String _address = '';

  void updateParentName(String value) => _parentName = value;
  void updateGovernment(String value) => _government = value;
  void updateAddress(String value) => _address = value;

  // ── Step 2: Child Information ─────────────────────────────────────────────
  String _childName = '';
  String _childBirthDate = '';
  String _childGender = 'male';

  void updateChildName(String value) => _childName = value;
  void updateChildBirthDate(String value) => _childBirthDate = value;
  void updateChildGender(String value) => _childGender = value;

  // ── Step 3: Contact Information ───────────────────────────────────────────
  String _phone = '';
  String _email = '';

  void updatePhone(String value) => _phone = value;
  void updateEmail(String value) => _email = value.trim();

  // ── Step 4: Password ──────────────────────────────────────────────────────
  String _password = '';
  String _verifiedToken = '';

  void updatePassword(String value) => _password = value;

  // ── Getter للـ OTP screen ─────────────────────────────────────────────────
  String get phone => ParentPhoneUtils.normalizeForApi(_phone);

  // ── Validation ────────────────────────────────────────────────────────────
  String? validateStep1() {
    if (_parentName.trim().isEmpty) return 'من فضلك ادخل الاسم';
    if (_parentName.trim().length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    if (_government.trim().isEmpty) return 'من فضلك اختر المحافظة';
    if (_address.trim().isEmpty) return 'من فضلك ادخل العنوان';
    return null;
  }

  String? validateStep2() {
    if (_childName.trim().isEmpty) return 'من فضلك ادخل اسم الطفل';
    if (_childBirthDate.trim().isEmpty) return 'من فضلك ادخل تاريخ الميلاد';
    return null;
  }

  String? validateStep3() {
    if (_phone.trim().isEmpty) return 'من فضلك ادخل رقم الهاتف';
    final normalizedPhone = ParentPhoneUtils.normalizeForApi(_phone);
    // Egyptian phone numbers are 11 digits and start with 01
    final phoneOk = RegExp(
      r'^01[0-9]{9}$',
    ).hasMatch(normalizedPhone.replaceAll(' ', ''));
    if (!phoneOk) return 'من فضلك ادخل رقم هاتف صحيح';
    if (_email.trim().isEmpty) return 'من فضلك ادخل البريد الإلكتروني';

    final email = _email.trim().toLowerCase();
    // Minimal, practical email validation for UI gating.
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailOk) return 'من فضلك ادخل بريد إلكتروني صحيح';
    return null;
  }

  String? validateStep4() {
    if (_password.trim().isEmpty) return 'من فضلك ادخل كلمة المرور';
    if (_password.trim().length < 6)
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  // ── Step 1 Next ───────────────────────────────────────────────────────────
  bool onStep1Next() {
    final error = validateStep1();
    if (error != null) {
      emit(SignUpFailure(message: error));
      emit(const SignUpInitial());
      return false;
    }
    return true;
  }

  // ── Step 2 Next ───────────────────────────────────────────────────────────
  bool onStep2Next() {
    final error = validateStep2();
    if (error != null) {
      emit(SignUpFailure(message: error));
      emit(const SignUpInitial());
      return false;
    }
    return true;
  }

  // ── Step 3 Next ───────────────────────────────────────────────────────────
  bool onStep3Next() {
    final error = validateStep3();
    if (error != null) {
      emit(SignUpFailure(message: error));
      emit(const SignUpInitial());
      return false;
    }
    return true;
  }

  // ── pre-SignUp: بيانات الأب والطفل + هاتف وبريد → إرسال OTP (بدون كلمة مرور)
  Future<void> preSignUp() async {
    final e1 = validateStep1();
    if (e1 != null) {
      emit(SignUpFailure(message: e1));
      return;
    }
    final e2 = validateStep2();
    if (e2 != null) {
      emit(SignUpFailure(message: e2));
      return;
    }
    final e3 = validateStep3();
    if (e3 != null) {
      emit(SignUpFailure(message: e3));
      return;
    }

    emit(const SignUpLoading());

    final apiPhone = ParentPhoneUtils.normalizeForApi(_phone);
    final apiEmail = _email.trim().toLowerCase();

    final result = await preSignUpUseCase(
      PreSignUpParams(
        parentName: _parentName.trim(),
        email: apiEmail,
        phone: apiPhone,
        government: _government.trim(),
        address: _address.trim(),
        // note 2: pre-sign-up must not include password (OTP is step 2).
        password: '',
        children: [
          ChildData(
            childName: _childName,
            gender: _childGender,
            birthDate: _childBirthDate,
          ),
        ],
      ),
    );

    result.fold(
      (f) => emit(SignUpFailure(message: f.message)),
      (_) {
        if (isClosed) return;
        emit(SignUpOtpSent(phone: apiPhone));
      },
    );
  }

  // ── verify-signUp: تأكيد OTP ─────────────────────────────────────────────
  Future<void> verifySignUp({required String otp}) async {
    emit(const SignUpLoading());
    final result = await verifySignUpUseCase(
      VerifySignUpParams(
        phone: ParentPhoneUtils.normalizeForApi(_phone),
        otp: otp,
      ),
    );
    result.fold(
      (f) => emit(SignUpFailure(message: f.message)),
      (token) {
        if (isClosed) return;
        _verifiedToken = token;
        emit(SignUpVerified(token: token));
      },
    );
  }

  /// After verify-signUp, set the real password using `/change-password`.
  Future<void> addPassword() async {
    final err = validateStep4();
    if (err != null) {
      emit(SignUpFailure(message: err));
      return;
    }
    if (_verifiedToken.trim().isEmpty) {
      emit(const SignUpFailure(message: 'لم يتم استلام التوكن'));
      return;
    }
    emit(const SignUpLoading());

    // Prefer the intended endpoint from notes: `/v1/parent/add-password`.
    final addRes = await addSignUpPasswordUseCase(
      AddSignUpPasswordParams(password: _password.trim()),
    );
    if (isClosed) return;

    // Production-safe behavior:
    // - Some deployments don't actually expose `/add-password` yet (404 "Cannot POST ...")
    // - Some return generic 500s
    // In both cases, fall back to the authenticated `/change-password` endpoint.
    final addOk = addRes.isRight();
    if (addOk) {
      emit(const SignUpPasswordCreated());
      return;
    }

    final changeRes = await changePasswordUseCase(
      ChangePasswordParams(
        phone: ParentPhoneUtils.normalizeForApi(_phone),
        password: _password.trim(),
        token: _verifiedToken,
      ),
    );
    if (isClosed) return;
    changeRes.fold(
      (f) {
        // If both endpoints fail, surface the *most actionable* error.
        // Prefer change-password message (usually auth/validation); else show add-password.
        emit(SignUpFailure(message: f.message));
      },
      (_) => emit(const SignUpPasswordCreated()),
    );
  }
}
