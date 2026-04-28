import 'package:dana/features/child_profile/data/models/growth_record_model.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

(int years, int months) ageFromBirth(DateTime? birthDate) {
  if (birthDate == null) return (0, 0);
  final now = DateTime.now();
  var y = now.year - birthDate.year;
  var m = now.month - birthDate.month;
  if (now.day < birthDate.day) m -= 1;
  if (m < 0) {
    y -= 1;
    m += 12;
  }
  return (y < 0 ? 0 : y, m < 0 ? 0 : m);
}

String statValue(double v, String unit) {
  if (v <= 0) return '—';
  final s = v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(1);
  return '$s $unit';
}

String deltaMonthly(
  GrowthRecord? latestMonth,
  GrowthRecord? previousMonth,
  double Function(GrowthRecord) pick,
  String unit,
) {
  if (latestMonth == null || previousMonth == null) return '—';
  final d = pick(latestMonth) - pick(previousMonth);
  if (d.abs() < 1e-6) return '—';
  final sign = d > 0 ? '+' : '';
  final val = d == d.roundToDouble()
      ? d.toStringAsFixed(0)
      : d.toStringAsFixed(1);
  return '$sign$val $unit';
}

/// Average checklist completion across skills that have at least one item.
int? averageSkillDevelopmentPercent(SkillsState s) {
  late final List<SkillApiModel> skills;
  late final Map<String, int> checked;
  late final Map<String, int> total;
  if (s is SkillsLoaded) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else if (s is ChecklistLoading) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else if (s is ChecklistLoaded) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else {
    return null;
  }
  if (skills.isEmpty) return null;
  var sum = 0;
  var n = 0;
  for (final sk in skills) {
    final t = total[sk.id] ?? 0;
    if (t <= 0) continue;
    final c = checked[sk.id] ?? 0;
    sum += ((c * 100) / t).round();
    n++;
  }
  if (n == 0) return null;
  return (sum / n).round();
}

String monthKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

Future<int?> previousMonthIndicator(String childId) async {
  final now = DateTime.now();
  final prev = DateTime(now.year, now.month - 1, 1);
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('skills_indicator_${childId}_${monthKey(prev)}');
}
