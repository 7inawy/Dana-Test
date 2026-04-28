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

    return SafeArea(
      top: false,
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
            final loading = state is ChecklistLoading || state is SkillsLoading;

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: HomeIndicator()),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.medium20TextDisplay(context),
                        ),
                      ),
                      _CloseButton(isDark: isDark),
                    ],
                  ),
                  if (description.trim().isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: AppTextStyle.regular16TextBody(context),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  if (loading) ...[
                    SizedBox(height: 12.h),
                    const Center(child: CircularProgressIndicator()),
                    SizedBox(height: 12.h),
                  ] else if (items.isEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        '—',
                        style: AppTextStyle.regular16TextBody(context),
                      ),
                    ),
                  ] else ...[
                    for (final item in items)
                      _ChecklistRow(
                        item: item,
                        isDark: isDark,
                        skillId: skillId,
                      ),
                  ],
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final bool isDark;

  const _CloseButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? AppColors.border_card_default_dark : AppColors.border_card_default_light;
    final bgColor =
        isDark ? AppColors.bg_surface_subtle_dark : AppColors.bg_surface_subtle_light;
    final iconColor = isDark ? AppColors.icon_onDark_dark : AppColors.icon_onLight_light;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonLabel,
      child: InkWell(
        onTap: () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.radius_sm),
            border: Border.all(color: borderColor, width: AppRadius.stroke_thin),
          ),
          child: Icon(Icons.close, color: iconColor, size: 20.sp),
        ),
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
