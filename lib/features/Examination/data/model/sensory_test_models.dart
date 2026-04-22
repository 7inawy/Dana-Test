class SensoryQuestionOption {
  final String label;
  final int value; // must be 1,2,3

  SensoryQuestionOption({required this.label, required this.value});

  factory SensoryQuestionOption.fromJson(Map<String, dynamic> json) {
    return SensoryQuestionOption(
      label: json['label']?.toString() ?? '',
      value: int.tryParse(json['value']?.toString() ?? '') ?? 0,
    );
  }
}

class SensoryQuestion {
  final String id;
  final String text;
  final String category; // seeking | avoiding | sensitivity | registration
  final List<SensoryQuestionOption> options;

  SensoryQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.options,
  });

  factory SensoryQuestion.fromJson(Map<String, dynamic> json) {
    final opts = (json['options'] as List?) ?? const [];
    return SensoryQuestion(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      options: opts
          .whereType<Map>()
          .map((e) => SensoryQuestionOption.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }
}

class SensoryTestAnswer {
  final String questionId;
  final int selectedValue; // must be 1,2,3

  SensoryTestAnswer({required this.questionId, required this.selectedValue});

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'selectedValue': selectedValue,
  };
}

class SensoryTestResult {
  final int totalScore;
  final String level; // low | medium | high
  final Map<String, int> categoryScores;

  SensoryTestResult({
    required this.totalScore,
    required this.level,
    required this.categoryScores,
  });

  factory SensoryTestResult.fromJson(Map<String, dynamic> json) {
    final cs = <String, int>{};
    final raw = json['categoryScores'];
    if (raw is Map) {
      for (final e in raw.entries) {
        if (e.key.toString() == '_id') continue;
        cs[e.key.toString()] = int.tryParse(e.value.toString()) ?? 0;
      }
    }
    return SensoryTestResult(
      totalScore: int.tryParse(json['totalScore']?.toString() ?? '') ?? 0,
      level: json['level']?.toString() ?? '',
      categoryScores: cs,
    );
  }
}
