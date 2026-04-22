import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';

/// Route arguments for [ChildProfileScreen] (and helpers building the same payload).
class ChildProfileArgs {
  const ChildProfileArgs({
    required this.childId,
    required this.childName,
    required this.gender,
    this.birthDate,
    this.profileImageUrl,
  });

  final String childId;
  final String childName;

  /// Backend value, e.g. `male` / `female`.
  final String gender;
  final DateTime? birthDate;
  final String? profileImageUrl;

  factory ChildProfileArgs.fromParentChild(ParentChildModel c) {
    return ChildProfileArgs(
      childId: c.id,
      childName: c.childName,
      gender: c.gender,
      birthDate: c.birthDate,
      profileImageUrl: c.profileImageUrl,
    );
  }
}
