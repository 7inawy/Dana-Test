class GrowthRecord {
  final String id;
  final String childId;
  final double height;
  final double weight;
  final double headCircumference;
  final DateTime recordDate;

  GrowthRecord({
    required this.id,
    required this.childId,
    required this.height,
    required this.weight,
    required this.headCircumference,
    required this.recordDate,
  });

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      id: json['_id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      height: double.tryParse(json['height']?.toString() ?? '') ?? 0,
      weight: double.tryParse(json['weight']?.toString() ?? '') ?? 0,
      headCircumference:
          double.tryParse(json['headCircumference']?.toString() ?? '') ?? 0,
      recordDate:
          DateTime.tryParse(json['recordDate']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
