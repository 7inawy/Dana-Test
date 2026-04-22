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

/// verifySignUp نجح – الحساب اتأكد
class SignUpVerified extends SignUpState {
  const SignUpVerified();
}

class SignUpFailure extends SignUpState {
  final String message;
  const SignUpFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
