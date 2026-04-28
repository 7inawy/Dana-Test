import 'dart:io';

import 'package:dana/core/errors/exceptions.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/parent_profile_model.dart';
import '../../data/repo/parent_profile_repository.dart';
import 'parent_profile_state.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final ParentProfileRepository repo;

  ParentProfileCubit(this.repo) : super(const ParentProfileInitial());

  ParentProfileModel? _lastGoodProfile;

  String _errMsg(Object e) => e is ServerException ? e.message : e.toString();

  void _evictNetworkImage(String? url) {
    if (url == null) return;
    final u = url.trim();
    if (u.isEmpty || !u.startsWith('http')) return;
    PaintingBinding.instance.imageCache.evict(NetworkImage(u));
  }

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
    final before = _lastGoodProfile;
    final beforeUrl = before?.children
        .firstWhere(
          (c) => c.id == childId,
          orElse: () => ParentChildModel(
            id: '',
            childName: '',
            gender: '',
            birthDate: null,
            profileImageUrl: null,
          ),
        )
        .profileImageUrl;
    try {
      await repo.updateChild(
        childId: childId,
        childName: childName,
        gender: gender,
        birthDate: birthDate,
        profileImage: profileImage,
      );
      // If the backend overwrites the image at the same URL, Flutter may keep
      // showing the old bitmap until the cache is evicted.
      if (profileImage != null) {
        _evictNetworkImage(beforeUrl);
      }
      await loadMe(silent: true);
      if (profileImage != null) {
        final afterUrl = _lastGoodProfile?.children
            .firstWhere(
              (c) => c.id == childId,
              orElse: () => ParentChildModel(
                id: '',
                childName: '',
                gender: '',
                birthDate: null,
                profileImageUrl: null,
              ),
            )
            .profileImageUrl;
        _evictNetworkImage(afterUrl);
      }
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
