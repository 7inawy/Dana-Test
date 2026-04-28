import 'package:dana/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum VaccineStatus { done, upcoming, delayed }

enum VaccineType { oral, injection }

enum LineStyle { none, solid, dashed }

class VaccineItem {
  final String? childId;
  final String? vaccinationId; // schedule item id
  final String title;
  final String description;
  final DateTime date;
  final DateTime? takenDate;
  VaccineStatus status;
  final VaccineType type;

  VaccineItem({
    this.childId,
    this.vaccinationId,
    required this.title,
    required this.description,
    required this.date,
    this.takenDate,
    required this.type,
    required this.status,
  });
}

class VaccineUIConfig {
  final Color color;
  final LineStyle lineStyle;
  final bool showButtons;

  VaccineUIConfig({
    required this.color,
    required this.lineStyle,
    required this.showButtons,
  });
}

VaccineUIConfig getUI(VaccineStatus status, bool isDark) {
  switch (status) {
    case VaccineStatus.done:
      return VaccineUIConfig(
        color: isDark
            ? AppColors.success_default_dark
            : AppColors.success_default_light,
        lineStyle: LineStyle.solid,
        showButtons: false,
      );

    case VaccineStatus.upcoming:
      return VaccineUIConfig(
        color: isDark
            ? AppColors.warning_default_dark
            : AppColors.warning_default_light,
        lineStyle: LineStyle.dashed,
        showButtons: true,
      );

    case VaccineStatus.delayed:
      return VaccineUIConfig(
        color: isDark
            ? AppColors.error_default_dark
            : AppColors.error_default_light,
        lineStyle: LineStyle.dashed,
        showButtons: true,
      );
  }
}

String getIconPath(VaccineType type) {
  switch (type) {
    case VaccineType.oral:
      return 'assets/Icons/vaccine/oral_icon.svg';

    case VaccineType.injection:
      return 'assets/Icons/vaccine/injection_icon.svg';
  }
}
