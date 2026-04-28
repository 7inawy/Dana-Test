import 'package:flutter/material.dart';

class CurrencyHelper {
  static String format(BuildContext context, num amount) {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    final number = _formatNumber(amount, isArabic);

    return isArabic ? '$number ج' : '$number LE';
  }

  static String _formatNumber(num number, bool isArabic) {
    final str = number.toString();

    if (!isArabic) return str;

    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    return str.replaceAllMapped(RegExp(r'\d'), (match) {
      return arabicDigits[int.parse(match.group(0)!)];
    });
  }
}
