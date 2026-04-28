import '../data/models/growth_record_model.dart';

String _monthKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}';

/// One [GrowthRecord] per calendar month: keeps the row with the latest
/// [GrowthRecord.recordDate] within that month.
List<GrowthRecord> growthRecordsOnePerMonth(List<GrowthRecord> raw) {
  final byMonth = <String, GrowthRecord>{};
  for (final r in raw) {
    final key = _monthKey(r.recordDate);
    final existing = byMonth[key];
    if (existing == null || r.recordDate.isAfter(existing.recordDate)) {
      byMonth[key] = r;
    }
  }
  final out = byMonth.values.toList()
    ..sort((a, b) => a.recordDate.compareTo(b.recordDate));
  return out;
}

/// Most recent monthly point and the prior month that has data.
(GrowthRecord? latestMonth, GrowthRecord? previousMonth) growthLatestTwoMonths(
  List<GrowthRecord> raw,
) {
  final monthly = growthRecordsOnePerMonth(raw);
  if (monthly.isEmpty) return (null, null);
  if (monthly.length == 1) return (monthly.last, null);
  return (monthly.last, monthly[monthly.length - 2]);
}

bool growthMonthlyBucketExists(List<GrowthRecord> raw, DateTime date) {
  final y = date.year;
  final m = date.month;
  return raw.any((r) => r.recordDate.year == y && r.recordDate.month == m);
}
