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
  final String? textEn;
  final String? textAr;
  final String category; // seeking | avoiding | sensitivity | registration
  final List<SensoryQuestionOption> options;

  SensoryQuestion({
    required this.id,
    required this.text,
    this.textEn,
    this.textAr,
    required this.category,
    required this.options,
  });

  factory SensoryQuestion.fromJson(Map<String, dynamic> json) {
    final opts = (json['options'] as List?) ?? const [];
    return SensoryQuestion(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      textEn: json['textEn']?.toString(),
      textAr: json['textAr']?.toString(),
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
  final double? percentage;
  final int? maxScore;

  SensoryTestResult({
    required this.totalScore,
    required this.level,
    required this.categoryScores,
    this.percentage,
    this.maxScore,
  });

  factory SensoryTestResult.fromJson(Map<String, dynamic> json) {
    // Backend sometimes wraps data in an envelope:
    // { response: { status, message, data: { test: {...}, percentage, maxScore } } }
    // While older/alternative shapes may be raw: { totalScore, level, categoryScores }.
    Map<String, dynamic> root = json;
    double? percentage;
    int? maxScore;

    final response = root['response'];
    if (response is Map) {
      final data = response['data'];
      if (data is Map) {
        percentage = double.tryParse(data['percentage']?.toString() ?? '');
        maxScore = int.tryParse(data['maxScore']?.toString() ?? '');

        final test = data['test'];
        if (test is Map) {
          root = test.cast<String, dynamic>();
        }
      }
    }

    final cs = <String, int>{};
    final raw = root['categoryScores'];
    if (raw is Map) {
      for (final e in raw.entries) {
        if (e.key.toString() == '_id') continue;
        cs[e.key.toString()] = int.tryParse(e.value.toString()) ?? 0;
      }
    }
    return SensoryTestResult(
      totalScore: int.tryParse(root['totalScore']?.toString() ?? '') ?? 0,
      level: root['level']?.toString() ?? '',
      categoryScores: cs,
      percentage: percentage,
      maxScore: maxScore,
    );
  }
}
