import 'dart:io';
import 'package:dana/features/auth/login/presentation/cubit/create_doctor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_doctor_usecase.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────
class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  final CreateDoctorUseCase createDoctorUseCase;

  CreateDoctorCubit({required this.createDoctorUseCase})
    : super(const CreateDoctorInitial());

  Future<void> createDoctor({
    required String doctorName,
    required String email,
    required String phone,
    required String password,
    required int detectionPrice,
    required int expires,
    required String specialty,
    required List<String> availableDates,
    required List<String> availableTimes,
    File? profileImage,
  }) async {
    emit(const CreateDoctorLoading());
    final result = await createDoctorUseCase(
      CreateDoctorParams(
        doctorName: doctorName,
        email: email,
        phone: phone,
        password: password,
        detectionPrice: detectionPrice,
        expires: expires,
        specialty: specialty,
        availableDates: availableDates,
        availableTimes: availableTimes,
        profileImage: profileImage,
      ),
    );
    result.fold(
      (f) => emit(CreateDoctorFailure(message: f.message)),
      (_) => emit(const CreateDoctorSuccess()),
    );
  }
}
