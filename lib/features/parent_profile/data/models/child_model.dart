class ChildModel {
  final String? id;
  final String name;
  final int years;
  final int months;
  final int gender;
  final DateTime? birthDate;
  final String? profileImageUrl;

  ChildModel({
    this.id,
    required this.name,
    required this.years,
    required this.months,
    required this.gender,
    this.birthDate,
    this.profileImageUrl,
  });
}
