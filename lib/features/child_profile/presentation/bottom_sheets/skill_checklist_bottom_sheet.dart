import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/skill_api_models.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';

class SkillChecklistBottomSheet extends StatelessWidget {
  final String skillId;
  final String title;
  final String description;

  const SkillChecklistBottomSheet({
    super.key,
    required this.skillId,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final primary = isDark
        ? AppColors.primary_default_dark
        : AppColors.primary_default_light;

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: 24.w,
          start: 24.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlocBuilder<SkillsCubit, SkillsState>(
          builder: (context, state) {
            final items = state is ChecklistLoaded
                ? state.items
                : <SkillChecklistItemApiModel>[];
            final loading =
                state is ChecklistLoading || state is SkillsLoading;

            return Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return primary;
                    }
                    return null;
                  }),
                  side: BorderSide(
                    color: isDark
                        ? AppColors.border_card_default_dark
                        : AppColors.border_card_default_light,
                    width: AppRadius.stroke_regular,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: HomeIndicator()),
                    SizedBox(height: 20.h),
                    Text(
                      title,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                      style: AppTextStyle.medium20TextDisplay(context),
                    ),
                    if (description.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        description,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                        style: AppTextStyle.regular16TextBody(context),
                      ),
                    ],
                    SizedBox(height: 16.h),
                    if (loading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      for (final item in items)
                        _ChecklistRow(
                          item: item,
                          isDark: isDark,
                          isRtl: isRtl,
                          skillId: skillId,
                        ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final SkillChecklistItemApiModel item;
  final bool isDark;
  final bool isRtl;
  final String skillId;

  const _ChecklistRow({
    required this.item,
    required this.isDark,
    required this.isRtl,
    required this.skillId,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? AppColors.border_card_default_dark
        : AppColors.border_card_default_light;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: item.checked
            ? (isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light)
            : (isDark
                  ? AppColors.bg_surface_subtle_dark
                  : AppColors.bg_surface_subtle_light),
        borderRadius: BorderRadius.circular(AppRadius.radius_md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.read<SkillsCubit>().toggle(
                  skillId: skillId,
                  itemId: item.id,
                  checked: !item.checked,
                );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.radius_md),
              border: Border.all(
                color: item.checked
                    ? (isDark
                          ? AppColors.primary_default_dark
                          : AppColors.primary_default_light)
                    : border,
                width: AppRadius.stroke_thin,
              ),
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: item.checked,
                    onChanged: (val) {
                      context.read<SkillsCubit>().toggle(
                            skillId: skillId,
                            itemId: item.id,
                            checked: val ?? false,
                          );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      item.title,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                      style: AppTextStyle.medium12TextBody(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
