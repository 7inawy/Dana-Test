class SkillApiModel {
  final String id;
  final String name;
  final int itemCount;

  SkillApiModel({
    required this.id,
    required this.name,
    required this.itemCount,
  });

  static int _parseItemCount(Map<String, dynamic> json) {
    final v = json['itemCount'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final n = int.tryParse(v.trim());
      if (n != null) return n;
    }
    final items = json['items'];
    if (items is List) return items.length;
    return 0;
  }

  factory SkillApiModel.fromJson(Map<String, dynamic> json) {
    return SkillApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      itemCount: _parseItemCount(json),
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

  static bool _parseChecked(dynamic v) {
    if (v == true) return true;
    if (v == false || v == null) return false;
    if (v is num) return v != 0;
    final s = v.toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }

  factory SkillChecklistItemApiModel.fromJson(Map<String, dynamic> json) {
    return SkillChecklistItemApiModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      checked: _parseChecked(json['checked']),
    );
  }
}
