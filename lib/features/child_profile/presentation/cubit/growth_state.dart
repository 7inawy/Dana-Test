import '../../data/models/growth_record_model.dart';

sealed class GrowthState {
  const GrowthState();
}

class GrowthInitial extends GrowthState {
  const GrowthInitial();
}

class GrowthLoading extends GrowthState {
  const GrowthLoading();
}

class GrowthLoaded extends GrowthState {
  final String childId;
  final String childName;
  final DateTime? birthDate;
  final String gender;
  final String? profileImageUrl;
  final List<GrowthRecord> records;
  final GrowthRecord? latest;

  const GrowthLoaded({
    required this.childId,
    required this.childName,
    this.birthDate,
    this.gender = '',
    this.profileImageUrl,
    required this.records,
    required this.latest,
  });
}

class GrowthError extends GrowthState {
  final String message;
  const GrowthError(this.message);
}
