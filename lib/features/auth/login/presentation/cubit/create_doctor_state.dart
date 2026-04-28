import 'package:equatable/equatable.dart';

abstract class CreateDoctorState extends Equatable {
  const CreateDoctorState();
  @override
  List<Object?> get props => [];
}

class CreateDoctorInitial extends CreateDoctorState {
  const CreateDoctorInitial();
}

class CreateDoctorLoading extends CreateDoctorState {
  const CreateDoctorLoading();
}

class CreateDoctorSuccess extends CreateDoctorState {
  const CreateDoctorSuccess();
}

class CreateDoctorFailure extends CreateDoctorState {
  final String message;
  const CreateDoctorFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
