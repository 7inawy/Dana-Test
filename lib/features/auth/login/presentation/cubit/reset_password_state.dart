import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

/// OTP اتبعت للهاتف
class ResetPasswordOtpSent extends ResetPasswordState {
  final String phone;
  const ResetPasswordOtpSent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

/// OTP اتتأكد – جاهز لتغيير الباسورد
class ResetPasswordOtpVerified extends ResetPasswordState {
  final String phone;
  final String otp;
  const ResetPasswordOtpVerified({required this.phone, required this.otp});
  @override
  List<Object?> get props => [phone, otp];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  const ResetPasswordFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
