import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

/// preSignUp نجح – OTP اتبعت
class SignUpOtpSent extends SignUpState {
  final String phone;
  const SignUpOtpSent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

/// verifySignUp نجح – جلسة مبدئية جاهزة لإكمال كلمة المرور
class SignUpVerified extends SignUpState {
  final String token;
  const SignUpVerified({required this.token});

  @override
  List<Object?> get props => [token];
}

/// add-password نجح – إكمال التسجيل
class SignUpPasswordCreated extends SignUpState {
  const SignUpPasswordCreated();
}

class SignUpFailure extends SignUpState {
  final String message;
  const SignUpFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
