import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String _formatYears(int years) {
    if (years == 1) return l10n.yearSingular;
    if (years == 2) return l10n.yearDual;
    return l10n.yearPlural(years);
  }

  String _formatMonths(int months) {
    if (months == 1) return l10n.monthSingular;
    if (months == 2) return l10n.monthDual;
    return l10n.monthPlural(months);
  }

  String formatAge(int years, int months) {
    final hasYears = years > 0;
    final hasMonths = months > 0;

    if (hasYears && hasMonths) {
      return l10n.ageFormatBoth(_formatYears(years), _formatMonths(months));
    }
    if (hasYears) return _formatYears(years);
    if (hasMonths) return _formatMonths(months);
    return '';
  }
}
