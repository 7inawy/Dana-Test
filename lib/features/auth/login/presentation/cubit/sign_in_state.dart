import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInLoading extends SignInState {
  const SignInLoading();
}

/// preSignIn نجح – OTP اتبعت للهاتف
class SignInOtpSent extends SignInState {
  final String phone;
  const SignInOtpSent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

/// verifySignIn نجح – اليوزر دخل وعنده التوكن
class SignInSuccess extends SignInState {
  final UserEntity user;
  const SignInSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class SignInFailure extends SignInState {
  final String message;
  const SignInFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
