import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/child_profile/data/models/growth_record_model.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/presentation/bottom_sheets/update_data_bottom_sheet.dart'
    show showUpdateMeasurementsBottomSheet;
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_state.dart';
import 'package:dana/features/child_profile/presentation/widget/custom_stat_card.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

(int years, int months) _ageFromBirth(DateTime? birthDate) {
  if (birthDate == null) return (0, 0);
  final now = DateTime.now();
  var y = now.year - birthDate.year;
  var m = now.month - birthDate.month;
  if (now.day < birthDate.day) m -= 1;
  if (m < 0) {
    y -= 1;
    m += 12;
  }
  return (y < 0 ? 0 : y, m < 0 ? 0 : m);
}

String _statValue(double v, String unit) {
  if (v <= 0) return '—';
  final s = v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(1);
  return '$s $unit';
}

String _deltaFor(
  GrowthRecord? latest,
  List<GrowthRecord> records,
  double Function(GrowthRecord) pick,
  String unit,
) {
  if (latest == null || records.length < 2) return '—';
  final sorted = [...records]
    ..sort((a, b) => a.recordDate.compareTo(b.recordDate));
  final prev = sorted.length >= 2 ? sorted[sorted.length - 2] : null;
  if (prev == null) return '—';
  final d = pick(latest) - pick(prev);
  if (d.abs() < 1e-6) return '—';
  final sign = d > 0 ? '+' : '';
  final val = d == d.roundToDouble()
      ? d.toStringAsFixed(0)
      : d.toStringAsFixed(1);
  return '$sign$val $unit';
}

/// Average checklist completion across skills that have at least one item.
int? _averageSkillDevelopmentPercent(SkillsState s) {
  late final List<SkillApiModel> skills;
  late final Map<String, int> checked;
  late final Map<String, int> total;
  if (s is SkillsLoaded) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else if (s is ChecklistLoading) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else if (s is ChecklistLoaded) {
    skills = s.skills;
    checked = s.skillCheckedById;
    total = s.skillTotalById;
  } else {
    return null;
  }
  if (skills.isEmpty) return null;
  var sum = 0;
  var n = 0;
  for (final sk in skills) {
    final t = total[sk.id] ?? 0;
    if (t <= 0) continue;
    final c = checked[sk.id] ?? 0;
    sum += ((c * 100) / t).round();
    n++;
  }
  if (n == 0) return null;
  return (sum / n).round();
}

class ChildInfoCard extends StatelessWidget {
  const ChildInfoCard({super.key, this.headerSnapshot});

  /// Shown while growth is loading; usually route [ChildProfileArgs].
  final ChildProfileArgs? headerSnapshot;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocBuilder<GrowthCubit, GrowthState>(
      builder: (context, growth) {
        final loaded = growth is GrowthLoaded ? growth : null;
        final snap = headerSnapshot;

        final name = loaded?.childName ?? snap?.childName ?? '';
        final birth = loaded?.birthDate ?? snap?.birthDate;
        final genderRaw = (loaded?.gender ?? snap?.gender ?? '').toLowerCase();
        final isGirl = genderRaw == 'female';
        final profileUrl = loaded?.profileImageUrl ?? snap?.profileImageUrl;

        final age = _ageFromBirth(birth);
        final ageText = context.formatAge(age.$1, age.$2);

        final latest = loaded?.latest;
        final records = loaded?.records ?? const <GrowthRecord>[];

        final heightVal = _statValue(latest?.height ?? 0, context.l10n.cm);
        final weightVal = _statValue(latest?.weight ?? 0, context.l10n.kg);
        final headVal = _statValue(
          latest?.headCircumference ?? 0,
          context.l10n.cm,
        );

        final dh = _deltaFor(latest, records, (e) => e.height, context.l10n.cm);
        final dw = _deltaFor(latest, records, (e) => e.weight, context.l10n.kg);
        final dhc = _deltaFor(
          latest,
          records,
          (e) => e.headCircumference,
          context.l10n.cm,
        );

        Widget avatar(double w) {
          final u = profileUrl;
          if (u != null && u.isNotEmpty && u.startsWith('http')) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                u,
                width: w,
                height: w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  isGirl
                      ? 'assets/Images/girl_child_photo.png'
                      : 'assets/Images/home/boy_child_photo.png',
                  width: w,
                ),
              ),
            );
          }
          return Image.asset(
            isGirl
                ? 'assets/Images/girl_child_photo.png'
                : 'assets/Images/home/boy_child_photo.png',
            width: w,
          );
        }

        final headerInk = loaded != null
            ? () => showUpdateMeasurementsBottomSheet(context)
            : null;

        return CustomFrame(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  onTap: headerInk,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        avatar(48.w),
                        Expanded(
                          child: Container(
                            margin: EdgeInsetsDirectional.only(start: 12.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name.isEmpty ? '…' : name,
                                      style: AppTextStyle.semibold16TextHeading(
                                        context,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      ageText.isEmpty ? '—' : ageText,
                                      style: AppTextStyle.medium12TextBody(
                                        context,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.h,
                                              horizontal: 16.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppColors.primary_50_dark
                                                  : AppColors.primary_50_light,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.radius_full,
                                                  ),
                                              border: Border.all(
                                                width: AppRadius.stroke_thin,
                                                color: isDark
                                                    ? AppColors.primary_200_dark
                                                    : AppColors
                                                          .primary_200_light,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                isGirl
                                                    ? context.l10n.girl
                                                    : context.l10n.boy,
                                                style:
                                                    AppTextStyle.medium12Primary(
                                                      context,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                              start: 8.w,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.h,
                                              horizontal: 16.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppColors
                                                        .bg_success_subtle_dark
                                                  : AppColors
                                                        .bg_success_subtle_light,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.radius_full,
                                                  ),
                                              border: Border.all(
                                                width: AppRadius.stroke_thin,
                                                color: isDark
                                                    ? AppColors
                                                          .success_default_dark
                                                    : AppColors
                                                          .success_default_light,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                context
                                                    .l10n
                                                    .growthStatusHealthy,
                                                style:
                                                    AppTextStyle.medium12Succes(
                                                      context,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  loaded != null
                                      ? Icons.edit_outlined
                                      : Icons.info_outline,
                                  size: 20.w,
                                  color: isDark
                                      ? AppColors.text_heading_dark
                                      : AppColors.text_heading_light,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 28.h,
                thickness: 0.5.h,
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
              ),
              IntrinsicHeight(
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
                        final pct = _averageSkillDevelopmentPercent(sk);
                        return CustomStatCard(
                          title: context.l10n.growthIndicator,
                          value: pct != null ? '$pct %' : '—',
                          change: '—',
                          iconPath:
                              'assets/Icons/child_profile/indicator_icon.svg',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
