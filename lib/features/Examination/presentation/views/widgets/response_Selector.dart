import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/features/Examination/presentation/views/widgets/response_Chip.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../data/model/examination_model.dart';

class ResponseSelector extends StatelessWidget {
  final ResponseOption? selectedOption;
  final ValueChanged<ResponseOption> onSelected;

  const ResponseSelector({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        border: Border.all(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
        ),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: ResponseOption.values.map((option) {
          final isLast = option == ResponseOption.values.last;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: isRtl ? (isLast ? 0 : 8.w) : 0,
                right: isRtl ? 0 : (isLast ? 0 : 8.w),
              ),
              child: ResponseChip(
                label: option.label(context),
                isSelected: selectedOption == option,
                onTap: () => onSelected(option),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
