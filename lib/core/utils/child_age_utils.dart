import '../constant/child_age_limits.dart';

/// Returns total elapsed whole months from [birthDate] to [now] (calendar-based).
int totalMonthsSinceBirth(DateTime birthDate, [DateTime? now]) {
  final n = now ?? DateTime.now();
  var years = n.year - birthDate.year;
  var months = n.month - birthDate.month;
  if (n.day < birthDate.day) months -= 1;
  if (months < 0) {
    years -= 1;
    months += 12;
  }
  if (years < 0) return 0;
  return years * 12 + (months < 0 ? 0 : months);
}

bool isAtLeastMinimumChildAge(DateTime birthDate) {
  return totalMonthsSinceBirth(birthDate) >= ChildAgeLimits.minimumTotalMonths;
}
