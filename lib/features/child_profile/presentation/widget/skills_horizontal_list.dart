import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/presentation/bottom_sheets/skill_checklist_bottom_sheet.dart';
import 'package:dana/features/child_profile/presentation/widget/skill_card.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/skill_card_model.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';
import 'skill_ui_utils.dart';

void _openSkillChecklist(
  BuildContext hostContext, {
  required SkillsCubit cubit,
  required String skillId,
  required String title,
}) {
  final themeProvider = hostContext.read<AppThemeProvider>();
  final isDark =
      themeProvider.appTheme == ThemeMode.dark ||
      (themeProvider.appTheme == ThemeMode.system &&
          MediaQuery.of(hostContext).platformBrightness == Brightness.dark);

  cubit.loadChecklist(skillId);
  showModalBottomSheet<void>(
    context: hostContext,
    isScrollControlled: true,
    backgroundColor: isDark
        ? AppColors.bg_surface_default_dark
        : AppColors.bg_surface_default_light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: SkillChecklistBottomSheet(
        skillId: skillId,
        title: title,
        description: '',
      ),
    ),
  );
}

class SkillsHorizontalList extends StatelessWidget {
  const SkillsHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkillsCubit, SkillsState>(
      builder: (context, state) {
        if (state is SkillsLoading || state is SkillsInitial) {
          return SizedBox(
            height: 168.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is SkillsError) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              state.message,
              style: AppTextStyle.medium12TextBody(context),
            ),
          );
        }

        late final List<SkillApiModel> skillList;
        late final Map<String, int> checked;
        late final Map<String, int> total;
        if (state is SkillsLoaded) {
          skillList = state.skills;
          checked = state.skillCheckedById;
          total = state.skillTotalById;
        } else if (state is ChecklistLoaded) {
          skillList = state.skills;
          checked = state.skillCheckedById;
          total = state.skillTotalById;
        } else if (state is ChecklistLoading) {
          skillList = state.skills;
          checked = state.skillCheckedById;
          total = state.skillTotalById;
        } else {
          skillList = const [];
          checked = const {};
          total = const {};
        }

        if (skillList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.skillsNotAvailableTitle,
                  style: AppTextStyle.semibold16TextHeading(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.skillsNotAvailableDesc,
                  style: AppTextStyle.regular12TextBody(context),
                ),
              ],
            ),
          );
        }

        final iconSrcs = [
          'assets/Icons/child_profile/motor_skill_icon.svg',
          'assets/Icons/child_profile/speech_skill_icon.svg',
          'assets/Icons/child_profile/cognition_skill_icon.svg',
          'assets/Icons/child_profile/social_skill_icon.svg',
        ];

        final cubit = context.read<SkillsCubit>();
        final visible = visibleSkillsUpToFour(skillList, total);

        final cards = <SkillCardData>[];
        for (var i = 0; i < visible.length; i++) {
          final s = visible[i];
          final done = checked[s.id] ?? 0;
          final tot = total[s.id] ?? 0;
          final countLabel = tot > 0 ? '$done/$tot' : '—';

          cards.add(
            SkillCardData(
              title: s.name,
              subtitle: '',
              count: countLabel,
              iconSrc: iconSrcs[i % iconSrcs.length],
              bottomSheetTitle: s.name,
              bottomSheetDescription: '',
              bottomSheetItems: const [],
              progressDone: done,
              progressTotal: tot,
            ),
          );
        }

        return SizedBox(
          height: 176.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: cards.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, i) {
              final s = visible[i];
              return SkillCard(
                data: cards[i],
                onTap: () => _openSkillChecklist(
                  context,
                  cubit: cubit,
                  skillId: s.id,
                  title: cards[i].title,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
