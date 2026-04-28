class AppointmentCalendarLogic {
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static List<DateTime> getMonthDays(DateTime month, DateTime now) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final List<DateTime> days = [];

    for (int i = 0; i <= lastDay.day - firstDay.day; i++) {
      final day = DateTime(month.year, month.month, 1 + i);
      days.add(DateTime(day.year, day.month, day.day));
    }

    final today = DateTime(now.year, now.month, now.day);

    if (month.year == now.year && month.month == now.month) {
      return days.where((d) => d.isAfter(today)).toList();
    }

    return days;
  }

  static bool isCurrentMonth(DateTime month) {
    final now = DateTime.now();
    return month.year == now.year && month.month == now.month;
  }
}
