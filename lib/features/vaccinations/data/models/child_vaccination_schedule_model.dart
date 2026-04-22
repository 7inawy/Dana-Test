class ChildVaccinationScheduleItem {
  final String id; // schedule item id (Postman uses "id")
  final VaccineDefinition vaccine;
  final DateTime dueDate;
  final DateTime? takenDate;
  final String status; // taken | pending | ...

  ChildVaccinationScheduleItem({
    required this.id,
    required this.vaccine,
    required this.dueDate,
    required this.takenDate,
    required this.status,
  });

  factory ChildVaccinationScheduleItem.fromJson(Map<String, dynamic> json) {
    final due = DateTime.tryParse(json['dueDate']?.toString() ?? '');
    final takenRaw = json['takenDate']?.toString();
    return ChildVaccinationScheduleItem(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      vaccine: VaccineDefinition.fromJson(
        (json['vaccine'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      dueDate: due ?? DateTime.now(),
      takenDate: (takenRaw == null || takenRaw.isEmpty)
          ? null
          : DateTime.tryParse(takenRaw),
      status: json['status']?.toString() ?? '',
    );
  }
}

class VaccineDefinition {
  final String id;
  final String name;
  final String description;
  final int? scheduleValue;
  final String? scheduleUnit;
  final bool isMandatory;

  VaccineDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.scheduleValue,
    required this.scheduleUnit,
    required this.isMandatory,
  });

  factory VaccineDefinition.fromJson(Map<String, dynamic> json) {
    return VaccineDefinition(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      scheduleValue: int.tryParse(json['scheduleValue']?.toString() ?? ''),
      scheduleUnit: json['scheduleUnit']?.toString(),
      isMandatory: json['isMandatory'] == true,
    );
  }
}
