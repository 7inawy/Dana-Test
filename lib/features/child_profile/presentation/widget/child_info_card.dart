import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/display_name_utils.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/child_profile/data/models/growth_record_model.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/skills_state.dart';
import 'package:dana/features/child_profile/domain/growth_monthly.dart';
import 'package:dana/features/child_profile/presentation/widget/custom_stat_card.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
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

String _deltaMonthly(
  GrowthRecord? latestMonth,
  GrowthRecord? previousMonth,
  double Function(GrowthRecord) pick,
  String unit,
) {
  if (latestMonth == null || previousMonth == null) return '—';
  final d = pick(latestMonth) - pick(previousMonth);
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

Widget _childProfileAvatar({
  required bool isGirl,
  required String? profileUrl,
  required double side,
}) {
  final u = profileUrl;
  if (u != null && u.isNotEmpty && u.startsWith('http')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        u,
        width: side,
        height: side,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          isGirl
              ? 'assets/Images/girl_child_photo.png'
              : 'assets/Images/home/boy_child_photo.png',
          width: side,
        ),
      ),
    );
  }
  return Image.asset(
    isGirl
        ? 'assets/Images/girl_child_photo.png'
        : 'assets/Images/home/boy_child_photo.png',
    width: side,
    height: side,
  );
}

class ChildInfoCard extends StatefulWidget {
  const ChildInfoCard({super.key, this.headerSnapshot, this.onSelectChild});

  /// Shown while growth is loading; usually route [ChildProfileArgs].
  final ChildProfileArgs? headerSnapshot;

  /// When the parent has multiple children, switches the active child (reload cubits from screen).
  final ValueChanged<String>? onSelectChild;

  @override
  State<ChildInfoCard> createState() => _ChildInfoCardState();
}

class _ChildInfoCardState extends State<ChildInfoCard> {
  bool _pickerExpanded = false;
  String? _lastSyncedChildId;

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
        final snap = widget.headerSnapshot;

        final name = loaded?.childName ?? snap?.childName ?? '';
        final displayName = DisplayNameUtils.dedupeRepeatedPhrase(name);
        final birth = loaded?.birthDate ?? snap?.birthDate;
        final genderRaw =
            (loaded != null ? loaded.gender : (snap?.gender ?? ''))
                .toLowerCase();
        final isGirl = genderRaw == 'female';
        final profileUrl = loaded?.profileImageUrl ?? snap?.profileImageUrl;

        final age = _ageFromBirth(birth);
        final ageText = context.formatAge(age.$1, age.$2);

        final records = loaded?.records ?? const <GrowthRecord>[];
        final monthlyPair = growthLatestTwoMonths(records);
        final latestMonth = monthlyPair.$1;
        final prevMonth = monthlyPair.$2;

        final heightVal = _statValue(latestMonth?.height ?? 0, context.l10n.cm);
        final weightVal = _statValue(latestMonth?.weight ?? 0, context.l10n.kg);
        final headVal = _statValue(
          latestMonth?.headCircumference ?? 0,
          context.l10n.cm,
        );

        final dh = _deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.height,
          context.l10n.cm,
        );
        final dw = _deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.weight,
          context.l10n.kg,
        );
        final dhc = _deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.headCircumference,
          context.l10n.cm,
        );

        if (loaded != null) {
          final cid = loaded.childId;
          if (_lastSyncedChildId != cid) {
            final hadPrevious = _lastSyncedChildId != null;
            _lastSyncedChildId = cid;
            if (hadPrevious && _pickerExpanded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _pickerExpanded = false);
              });
            }
          }
        }

        final showChildPicker =
            loaded != null &&
            loaded.children.length > 1 &&
            widget.onSelectChild != null;

        final otherChildren = loaded == null
            ? const <ParentChildModel>[]
            : loaded.children
                  .where((c) => c.id != loaded.childId)
                  .toList(growable: false);

        return CustomFrame(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppRadius.radius_sm,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _childProfileAvatar(
                                  isGirl: isGirl,
                                  profileUrl: profileUrl,
                                  side: 48.w,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                      start: 12.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              displayName.isEmpty
                                                  ? '…'
                                                  : displayName,
                                              style:
                                                  AppTextStyle.semibold16TextHeading(
                                                    context,
                                                  ),
                                            ),
                                            if (showChildPicker)
                                              Container(
                                                width: 20.w,
                                                height: 20.h,
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                      end: 4.w,
                                                    ),
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () => setState(
                                                      () => _pickerExpanded =
                                                          !_pickerExpanded,
                                                    ),
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    padding:
                                                        EdgeInsetsDirectional.only(
                                                          start: 4.w,
                                                        ),
                                                    constraints: BoxConstraints(
                                                      minWidth: 20.w,
                                                      minHeight: 20.h,
                                                    ),
                                                    icon: Container(
                                                      width: 20.w,
                                                      height: 20.h,
                                                      margin:
                                                          EdgeInsetsDirectional.only(
                                                            end: 4.w,
                                                          ),
                                                      child: Center(
                                                        child: Icon(
                                                          _pickerExpanded
                                                              ? Icons
                                                                    .expand_less
                                                              : Icons
                                                                    .expand_more,
                                                          color: isDark
                                                              ? AppColors
                                                                    .icon_onLight_dark
                                                              : AppColors
                                                                    .icon_onLight_light,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else if (loaded == null)
                                              Icon(
                                                Icons.info_outline,
                                                size: 20.w,
                                                color: isDark
                                                    ? AppColors
                                                          .icon_onLight_dark
                                                    : AppColors
                                                          .icon_onLight_light,
                                              )
                                            else
                                              SizedBox(width: 4.w),
                                          ],
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
                                                  color: isGirl
                                                      ? (isDark
                                                            ? const Color.fromARGB(
                                                                255,
                                                                68,
                                                                26,
                                                                60,
                                                              )
                                                            : const Color.fromARGB(
                                                                255,
                                                                249,
                                                                230,
                                                                244,
                                                              ))
                                                      : (isDark
                                                            ? AppColors
                                                                  .primary_50_dark
                                                            : AppColors
                                                                  .primary_50_light),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppRadius.radius_full,
                                                      ),
                                                  border: Border.all(
                                                    width:
                                                        AppRadius.stroke_thin,
                                                    color: isGirl
                                                        ? (isDark
                                                              ? const Color.fromARGB(
                                                                  255,
                                                                  128,
                                                                  33,
                                                                  117,
                                                                )
                                                              : const Color.fromARGB(
                                                                  255,
                                                                  226,
                                                                  138,
                                                                  226,
                                                                ))
                                                        : (isDark
                                                              ? AppColors
                                                                    .primary_200_dark
                                                              : AppColors
                                                                    .primary_200_light),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    isGirl
                                                        ? context.l10n.girl
                                                        : context.l10n.boy,
                                                    style: isGirl
                                                        ? AppTextStyle.medium12Pink(
                                                            context,
                                                          )
                                                        : AppTextStyle.medium12Primary(
                                                            context,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
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
                                                    width:
                                                        AppRadius.stroke_thin,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showChildPicker &&
                  _pickerExpanded &&
                  otherChildren.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.bg_surface_subtle_dark
                          : AppColors.bg_surface_subtle_light,
                      borderRadius: BorderRadius.circular(AppRadius.radius_md),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < otherChildren.length; i++) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              thickness: 0.5.h,
                              color: isDark
                                  ? AppColors.border_card_default_dark
                                  : AppColors.border_card_default_light,
                            ),
                          InkWell(
                            onTap: () {
                              final id = otherChildren[i].id;
                              setState(() => _pickerExpanded = false);
                              widget.onSelectChild!(id);
                            },
                            borderRadius: i == 0
                                ? BorderRadius.vertical(
                                    top: Radius.circular(AppRadius.radius_md),
                                  )
                                : i == otherChildren.length - 1
                                ? BorderRadius.vertical(
                                    bottom: Radius.circular(
                                      AppRadius.radius_md,
                                    ),
                                  )
                                : null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _childProfileAvatar(
                                    isGirl:
                                        otherChildren[i].gender.toLowerCase() ==
                                        'female',
                                    profileUrl:
                                        otherChildren[i].profileImageUrl,
                                    side: 44.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DisplayNameUtils.dedupeRepeatedPhrase(
                                            otherChildren[i].childName,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              AppTextStyle.semibold16TextHeading(
                                                context,
                                              ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          context.formatAge(
                                            _ageFromBirth(
                                              otherChildren[i].birthDate,
                                            ).$1,
                                            _ageFromBirth(
                                              otherChildren[i].birthDate,
                                            ).$2,
                                          ),
                                          style: AppTextStyle.medium12TextBody(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
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
