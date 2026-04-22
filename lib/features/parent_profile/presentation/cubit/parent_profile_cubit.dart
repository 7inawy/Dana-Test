import 'dart:io';

import 'package:dana/core/errors/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/parent_profile_repository.dart';
import 'parent_profile_state.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final ParentProfileRepository repo;

  ParentProfileCubit(this.repo) : super(const ParentProfileInitial());

  String _errMsg(Object e) => e is ServerException ? e.message : e.toString();

  Future<void> loadMe({bool silent = false}) async {
    if (!silent) emit(const ParentProfileLoading());
    try {
      final profile = await repo.getMe();
      emit(ParentProfileLoaded(profile));
    } catch (e) {
      emit(ParentProfileError(_errMsg(e)));
    }
  }

  /// Updates parent fields via `PATCH /v1/parentMe`. Returns `null` on success.
  Future<String?> updateProfile({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
  }) async {
    try {
      final profile = await repo.updateProfile(
        parentName: parentName,
        email: email,
        phone: phone,
        government: government,
        address: address,
      );
      emit(ParentProfileLoaded(profile));
      return null;
    } catch (e) {
      final msg = _errMsg(e);
      try {
        final profile = await repo.getMe();
        emit(ParentProfileLoaded(profile));
      } catch (_) {
        emit(ParentProfileError(msg));
      }
      return msg;
    }
  }

  Future<void> addChild({
    required String childName,
    required String gender,
    required DateTime birthDate,
  }) async {
    try {
      await repo.addChild(
        childName: childName,
        gender: gender,
        birthDate: birthDate,
      );
      await loadMe(silent: true);
    } catch (e) {
      emit(ParentProfileError(_errMsg(e)));
    }
  }

  Future<String?> updateChild({
    required String childId,
    required String childName,
    required String gender,
    required DateTime birthDate,
    File? profileImage,
  }) async {
    try {
      await repo.updateChild(
        childId: childId,
        childName: childName,
        gender: gender,
        birthDate: birthDate,
        profileImage: profileImage,
      );
      await loadMe(silent: true);
      return null;
    } catch (e) {
      final msg = _errMsg(e);
      try {
        final profile = await repo.getMe();
        emit(ParentProfileLoaded(profile));
      } catch (_) {
        emit(ParentProfileError(msg));
      }
      return msg;
    }
  }
}
