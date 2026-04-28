import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).languageCode;
  return DateFormat('EEEE, d MMMM', locale).format(date);
}

String formatTime(BuildContext context, TimeOfDay start, TimeOfDay end) {
  final locale = Localizations.localeOf(context).languageCode;

  final now = DateTime.now();

  final startDate = DateTime(
    now.year,
    now.month,
    now.day,
    start.hour,
    start.minute,
  );

  final endDate = DateTime(now.year, now.month, now.day, end.hour, end.minute);

  final formatter = DateFormat.jm(locale);

  return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
}

String formatSingleTime(BuildContext context, TimeOfDay time) {
  final locale = Localizations.localeOf(context).languageCode;

  final now = DateTime.now();

  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  final formatter = DateFormat.jm(locale);

  return formatter.format(dateTime);
}
