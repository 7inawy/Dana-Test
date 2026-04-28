import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_state.dart';
import 'package:dana/features/child_profile/presentation/widget/child_info_card_helpers.dart';
import 'package:dana/features/child_profile/presentation/widget/custom_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildStatsRow extends StatelessWidget {
  final String heightVal;
  final String weightVal;
  final String headVal;
  final String dh;
  final String dw;
  final String dhc;
  final GrowthState growth;

  const ChildStatsRow({
    super.key,
    required this.heightVal,
    required this.weightVal,
    required this.headVal,
    required this.dh,
    required this.dw,
    required this.dhc,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomStatCard(
            title: context.l10n.height,
            value: heightVal,
            change: dh,
            iconPath: 'assets/Icons/child_profile/ruler_icon.svg',
          ),
          SizedBox(width: 8.w),
          CustomStatCard(
            title: context.l10n.weight,
            value: weightVal,
            change: dw,
            iconPath: 'assets/Icons/child_profile/weight_icon.svg',
          ),
          SizedBox(width: 8.w),
          CustomStatCard(
            title: context.l10n.headCircumference,
            value: headVal,
            change: dhc,
            iconPath: 'assets/Icons/child_profile/brain_icon.svg',
          ),
          SizedBox(width: 8.w),
          BlocBuilder<SkillsCubit, SkillsState>(
            builder: (context, sk) {
              final pct = averageSkillDevelopmentPercent(sk);
              final childId = switch (growth) {
                GrowthLoaded g => g.childId,
                _ => '',
              };
              if (pct == null || childId.isEmpty) {
                return CustomStatCard(
                  title: context.l10n.growthIndicator,
                  value: '—',
                  change: '—',
                  iconPath: 'assets/Icons/child_profile/indicator_icon.svg',
                );
              }
              return FutureBuilder<int?>(
                future: previousMonthIndicator(childId),
                builder: (context, snap) {
                  final prev = snap.data;
                  final delta = prev == null ? null : (pct - prev);
                  final change = delta == null
                      ? '—'
                      : delta == 0
                      ? '—'
                      : '${delta > 0 ? '+' : ''}$delta %';
                  final changeColor = delta == null || delta <= 0
                      ? (isDark
                            ? AppColors.icon_onLight_dark
                            : AppColors.icon_onLight_light)
                      : (isDark
                            ? AppColors.success_default_dark
                            : AppColors.success_default_light);
                  return CustomStatCard(
                    title: context.l10n.growthIndicator,
                    value: '$pct %',
                    change: change,
                    changeColor: changeColor,
                    iconPath: 'assets/Icons/child_profile/indicator_icon.svg',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
