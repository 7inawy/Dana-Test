import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_localizations.dart';

enum ResponseOption { always, sometimes, rarely }

extension ResponseOptionLabel on ResponseOption {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ResponseOption.rarely:
        return l10n.responseRarely;
      case ResponseOption.sometimes:
        return l10n.responseSometimes;
      case ResponseOption.always:
        return l10n.responseAlways;
    }
  }
}

class ExamQuestion {
  final String text;
  ResponseOption? selectedOption;

  ExamQuestion({required this.text, this.selectedOption});
}

class ExamSection {
  final String title;
  final String? subtitle;
  final List<ExamQuestion> questions;

  ExamSection({required this.title, this.subtitle, required this.questions});
}
