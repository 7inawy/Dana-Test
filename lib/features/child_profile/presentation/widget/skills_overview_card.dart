import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_state.dart';
import 'package:dana/features/child_profile/presentation/widget/skill_row.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

int _percentForSkill(
  SkillApiModel s,
  Map<String, int> checked,
  Map<String, int> total,
) {
  final t = total[s.id] ?? 0;
  if (t <= 0) return 0;
  final c = checked[s.id] ?? 0;
  return ((c * 100) / t).round().clamp(0, 100);
}

class SkillsOverviewCard extends StatelessWidget {
  const SkillsOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return CustomFrame(
      vPadding: 8.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: Container(
              padding: EdgeInsetsDirectional.only(
                top: 48.h,
                bottom: 38.h,
                end: 24.w,
                start: 24.w,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light,
                borderRadius: BorderRadius.circular(AppRadius.radius_full),
              ),
              child: Container(
                padding: EdgeInsetsDirectional.only(
                  top: 18.h,
                  bottom: 28.h,
                  start: 1.5.w,
                  end: 1.5.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.radius_full),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 4.w,
                      blurRadius: 24.w,
                      color: isDark
                          ? AppColors.primary_200_dark
                          : AppColors.primary_200_light,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/Icons/child_profile/child_status.svg',
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? AppColors.primary_default_dark
                        : AppColors.primary_default_light,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.5.h),
              child: BlocBuilder<SkillsCubit, SkillsState>(
                builder: (context, state) {
                  if (state is SkillsLoading || state is SkillsInitial) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is SkillsError) {
                    return Text(
                      state.message,
                      style: AppTextStyle.medium12TextBody(context),
                    );
                  }

                  late final List<SkillApiModel> skills;
                  late final Map<String, int> checked;
                  late final Map<String, int> total;
                  if (state is SkillsLoaded) {
                    skills = state.skills;
                    checked = state.skillCheckedById;
                    total = state.skillTotalById;
                  } else if (state is ChecklistLoading) {
                    skills = state.skills;
                    checked = state.skillCheckedById;
                    total = state.skillTotalById;
                  } else if (state is ChecklistLoaded) {
                    skills = state.skills;
                    checked = state.skillCheckedById;
                    total = state.skillTotalById;
                  } else {
                    return const SizedBox.shrink();
                  }

                  final visibleSkills = skills
                      .where((s) => (total[s.id] ?? 0) > 0)
                      .take(4)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.childGrowthTitle,
                        style: AppTextStyle.semibold16TextHeading(context),
                      ),
                      SizedBox(height: 16.h),
                      if (skills.isEmpty) ...[
                        Text(
                          context.l10n.skillsNotAvailableTitle,
                          style: AppTextStyle.semibold16TextHeading(context),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          context.l10n.skillsNotAvailableDesc,
                          style: AppTextStyle.regular12TextBody(context),
                        ),
                      ] else if (visibleSkills.isEmpty)
                        Text(
                          '—',
                          style: AppTextStyle.regular12TextBody(context),
                        )
                      else
                        for (final s in visibleSkills)
                          SkillRow(
                            label: s.name,
                            value: _percentForSkill(s, checked, total),
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
