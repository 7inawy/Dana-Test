import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class GoogleCompleteValidators {
  static const int maxGovernmentLen = 50;
  static const int maxAddressLen = 120;
  static const int maxChildNameLen = 50;

  static String? requiredText(BuildContext context, String? v) {
    if (v == null || v.trim().isEmpty) return context.l10n.fieldRequired;
    return null;
  }

  static String? validateGovernment(BuildContext context, String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return context.l10n.fieldRequired;
    if (s.length > maxGovernmentLen) {
      return context.l10n.maxCharacters(maxGovernmentLen);
    }
    // Arabic/English letters + spaces + hyphen
    final ok = RegExp(r'^[\p{L}\s-]+$', unicode: true).hasMatch(s);
    if (!ok) return context.l10n.onlyLettersAllowed;
    return null;
  }

  static String? validateAddress(BuildContext context, String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return context.l10n.fieldRequired;
    if (s.length > maxAddressLen) {
      return context.l10n.maxCharacters(maxAddressLen);
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return context.l10n.fieldRequired;
    if (s.length < 8) return context.l10n.passwordMinChars(8);
    if (s.length > 64) return context.l10n.passwordMaxChars(64);
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(s);
    final hasNumber = RegExp(r'\d').hasMatch(s);
    if (!hasLetter || !hasNumber) return context.l10n.passwordLettersAndNumbers;
    return null;
  }

  static String? validateChildName(BuildContext context, String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return context.l10n.fieldRequired;
    if (s.length > maxChildNameLen) {
      return context.l10n.maxCharacters(maxChildNameLen);
    }
    final ok = RegExp(r'^[\p{L}\s-]+$', unicode: true).hasMatch(s);
    if (!ok) return context.l10n.onlyLettersAllowed;
    return null;
  }

  static String? validateBirthDate(BuildContext context, String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return context.l10n.fieldRequired;
    final match = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s);
    if (!match) return context.l10n.birthDateFormatYyyyMmDd;
    final parsed = DateTime.tryParse(s);
    if (parsed == null) return context.l10n.invalidDate;
    final today = DateTime.now();
    final date = DateTime(parsed.year, parsed.month, parsed.day);
    final nowDate = DateTime(today.year, today.month, today.day);
    if (date.isAfter(nowDate)) return context.l10n.dateMustBePast;

    final years = nowDate.year -
        date.year -
        ((nowDate.month < date.month ||
                (nowDate.month == date.month && nowDate.day < date.day))
            ? 1
            : 0);
    if (years > 18) return context.l10n.childAgeRange;
    return null;
  }

  static String fmtYyyyMmDd(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}

