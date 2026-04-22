class SkillApiModel {
  final String id;
  final String name;
  final int itemCount;

  SkillApiModel({
    required this.id,
    required this.name,
    required this.itemCount,
  });

  factory SkillApiModel.fromJson(Map<String, dynamic> json) {
    return SkillApiModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      itemCount: int.tryParse(json['itemCount']?.toString() ?? '') ?? 0,
    );
  }
}

class SkillChecklistItemApiModel {
  final String id;
  final String title;
  final bool checked;

  SkillChecklistItemApiModel({
    required this.id,
    required this.title,
    required this.checked,
  });

  factory SkillChecklistItemApiModel.fromJson(Map<String, dynamic> json) {
    return SkillChecklistItemApiModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      checked: json['checked'] == true,
    );
  }
}
