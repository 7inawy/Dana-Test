import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object?> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthLaunchUrl extends GoogleAuthState {
  final String url;
  const GoogleAuthLaunchUrl({required this.url});

  @override
  List<Object?> get props => [url];
}

class GoogleAuthCompleteLoading extends GoogleAuthState {
  const GoogleAuthCompleteLoading();
}

class GoogleAuthSuccess extends GoogleAuthState {
  final UserEntity user;
  const GoogleAuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class GoogleAuthFailure extends GoogleAuthState {
  final String message;
  const GoogleAuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

