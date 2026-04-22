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

    return Padding(
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
          final loading = state is ChecklistLoading || state is SkillsLoading;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: HomeIndicator()),
                SizedBox(height: 20.h),
                Text(title, style: AppTextStyle.medium20TextDisplay(context)),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: AppTextStyle.regular16TextBody(context),
                ),
                SizedBox(height: 12.h),
                if (loading) const Center(child: CircularProgressIndicator()),
                if (!loading)
                  for (final item in items)
                    _ChecklistRow(item: item, isDark: isDark, skillId: skillId),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final SkillChecklistItemApiModel item;
  final bool isDark;
  final String skillId;

  const _ChecklistRow({
    required this.item,
    required this.isDark,
    required this.skillId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SkillsCubit>().toggle(
          skillId: skillId,
          itemId: item.id,
          checked: !item.checked,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: item.checked
              ? isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light
              : isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_md),
          border: Border.all(
            color: item.checked
                ? isDark
                      ? AppColors.primary_default_dark
                      : AppColors.primary_default_light
                : isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Checkbox(
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
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyle.medium16TextBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
