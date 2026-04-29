import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../l10n/app_localizations.dart';

class CurrencyHelper {
  static String format(BuildContext context, num amount) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final localeName = AppLocalizations.of(context)?.localeName ?? locale.toString();

    final number = intl.NumberFormat.decimalPattern(localeName).format(amount);
    return isArabic ? '$number ج' : '$number LE';
  }
}
