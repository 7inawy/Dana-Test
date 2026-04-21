import 'package:equatable/equatable.dart';

import '../../data/models/public_doctor_model.dart';

abstract class DoctorsListState extends Equatable {
  const DoctorsListState();

  @override
  List<Object?> get props => [];
}

class DoctorsListInitial extends DoctorsListState {
  const DoctorsListInitial();
}

class DoctorsListLoading extends DoctorsListState {
  const DoctorsListLoading();
}

class DoctorsListLoaded extends DoctorsListState {
  const DoctorsListLoaded(this.doctors);

  final List<PublicDoctorModel> doctors;

  @override
  List<Object?> get props => [doctors];
}

class DoctorsListError extends DoctorsListState {
  const DoctorsListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
