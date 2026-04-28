import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class CreateDoctorUseCase extends UseCase<Unit, CreateDoctorParams> {
  final AuthRepository repository;
  CreateDoctorUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(CreateDoctorParams params) {
    return repository.createDoctor(
      doctorName: params.doctorName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      detectionPrice: params.detectionPrice,
      expires: params.expires,
      specialty: params.specialty,
      availableDates: params.availableDates,
      availableTimes: params.availableTimes,
      profileImage: params.profileImage,
    );
  }
}

class CreateDoctorParams extends Equatable {
  final String doctorName;
  final String email;
  final String phone;
  final String password;
  final int detectionPrice;
  final int expires;
  final String specialty;
  final List<String> availableDates; // YYYY-MM-DD
  final List<String> availableTimes; // HH:MM
  final File? profileImage;

  const CreateDoctorParams({
    required this.doctorName,
    required this.email,
    required this.phone,
    required this.password,
    required this.detectionPrice,
    required this.expires,
    required this.specialty,
    required this.availableDates,
    required this.availableTimes,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    doctorName,
    email,
    phone,
    password,
    detectionPrice,
    expires,
    specialty,
    availableDates,
    availableTimes,
  ];
}
