import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../repo/auth_repository.dart';

class PreSignUpUseCase extends UseCase<Unit, PreSignUpParams> {
  final AuthRepository repository;
  PreSignUpUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(PreSignUpParams params) {
    return repository.preSignUp(
      parentName: params.parentName,
      email: params.email,
      phone: params.phone,
      government: params.government,
      address: params.address,
      password: params.password,
      children: params.children,
      profileImage: params.profileImage,
    );
  }
}

class PreSignUpParams extends Equatable {
  final String parentName;
  final String email;
  final String phone;
  final String government;
  final String address;
  final String password;
  final List<ChildData> children;
  final File? profileImage;

  const PreSignUpParams({
    required this.parentName,
    required this.email,
    required this.phone,
    required this.government,
    required this.address,
    required this.password,
    required this.children,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    parentName,
    email,
    phone,
    government,
    address,
    password,
    children,
  ];
}
