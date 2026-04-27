import 'dart:io';

import 'package:dana/core/errors/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/parent_profile_model.dart';
import '../../data/repo/parent_profile_repository.dart';
import 'parent_profile_state.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final ParentProfileRepository repo;

  ParentProfileCubit(this.repo) : super(const ParentProfileInitial());

  ParentProfileModel? _lastGoodProfile;

  String _errMsg(Object e) => e is ServerException ? e.message : e.toString();

  Future<void> loadMe({bool silent = false}) async {
    if (!silent) emit(const ParentProfileLoading());
    try {
      final profile = await repo.getMe();
      _lastGoodProfile = profile;
      emit(ParentProfileLoaded(profile));
    } catch (e) {
      if (silent && _lastGoodProfile != null) {
        emit(ParentProfileLoaded(_lastGoodProfile!));
        return;
      }
      emit(ParentProfileError(_errMsg(e)));
    }
  }

  /// Sends an SMS OTP to [phone] for changing the account phone (authenticated).
  Future<String?> requestPhoneChangeOtp({required String phone}) async {
    try {
      await repo.sendPhoneChangeOtp(phone: phone);
      return null;
    } catch (e) {
      return _errMsg(e);
    }
  }

  /// Updates parent fields via `PATCH /v1/parentMe` then refetches profile. Returns `null` on success.
  /// When changing phone, pass [phoneOtp] after the user verifies the code sent to the new number.
  Future<String?> updateProfile({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
    String? phoneOtp,
  }) async {
    try {
      final profile = await repo.updateProfile(
        parentName: parentName,
        email: email,
        phone: phone,
        government: government,
        address: address,
        phoneOtp: phoneOtp,
      );
      _lastGoodProfile = profile;
      emit(ParentProfileLoaded(profile));
      return null;
    } catch (e) {
      final msg = _errMsg(e);
      try {
        final profile = await repo.getMe();
        _lastGoodProfile = profile;
        emit(ParentProfileLoaded(profile));
      } catch (_) {
        if (_lastGoodProfile != null) {
          emit(ParentProfileLoaded(_lastGoodProfile!));
        } else {
          emit(ParentProfileError(msg));
        }
      }
      return msg;
    }
  }

  /// Returns `null` on success, otherwise an error message for a SnackBar.
  Future<String?> addChild({
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
      return null;
    } catch (e) {
      final msg = _errMsg(e);
      if (_lastGoodProfile != null) {
        emit(ParentProfileLoaded(_lastGoodProfile!));
      } else {
        emit(ParentProfileError(msg));
      }
      return msg;
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
        _lastGoodProfile = profile;
        emit(ParentProfileLoaded(profile));
      } catch (_) {
        if (_lastGoodProfile != null) {
          emit(ParentProfileLoaded(_lastGoodProfile!));
        } else {
          emit(ParentProfileError(msg));
        }
      }
      return msg;
    }
  }

  /// Updates parent profile photo via multipart `POST /v1/parent/:id/add-profile-image`.
  /// Returns `null` on success.
  Future<String?> updateProfilePhoto(File photo) async {
    final cur = _lastGoodProfile;
    if (cur == null) {
      return 'noProfile';
    }
    try {
      final profile = await repo.updateProfilePhoto(current: cur, photo: photo);
      _lastGoodProfile = profile;
      emit(ParentProfileLoaded(profile));
      return null;
    } catch (e) {
      return _errMsg(e);
    }
  }
}
