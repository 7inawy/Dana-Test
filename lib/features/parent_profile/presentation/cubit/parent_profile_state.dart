import '../../data/models/parent_profile_model.dart';

sealed class ParentProfileState {
  const ParentProfileState();
}

class ParentProfileInitial extends ParentProfileState {
  const ParentProfileInitial();
}

class ParentProfileLoading extends ParentProfileState {
  const ParentProfileLoading();
}

class ParentProfileLoaded extends ParentProfileState {
  final ParentProfileModel profile;
  const ParentProfileLoaded(this.profile);
}

class ParentProfileError extends ParentProfileState {
  final String message;
  const ParentProfileError(this.message);
}
