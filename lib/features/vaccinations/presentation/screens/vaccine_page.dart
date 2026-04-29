import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/vaccinations/data/models/vaccine_model.dart';
import 'package:dana/features/home/presentation/widgets/child_selector_header.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:dana/features/vaccinations/presentation/widgets/painters.dart';
import 'package:dana/features/vaccinations/presentation/widgets/vaccine_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/vaccination_schedule_cubit.dart';
import '../cubit/vaccination_schedule_state.dart';
import '../../data/models/child_vaccination_schedule_model.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key, this.childId});

  /// When null, the schedule uses the first child from the parent profile.
  final String? childId;

  static const String routeName = 'VaccineScreen';

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  late final VaccinationScheduleCubit _cubit;
  late final ParentProfileCubit _parentProfileCubit;
  String? _selectedChildId;
  bool _childPickerExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.childId;
    _cubit = sl<VaccinationScheduleCubit>()..load(childId: widget.childId);
    _parentProfileCubit = sl<ParentProfileCubit>()..loadMe();
  }

  @override
  void dispose() {
    _cubit.close();
    _parentProfileCubit.close();
    super.dispose();
  }

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

  void _ensureValidSelectedChild(ParentProfileState pState) {
    if (pState is! ParentProfileLoaded) return;
    final children = pState.profile.children;
    if (children.isEmpty) {
      if (_selectedChildId != null && _selectedChildId!.isNotEmpty) {
        setState(() => _selectedChildId = '');
      }
      return;
    }
    final ids = children.map((e) => e.id).toSet();
    final current = _selectedChildId;
    if (current == null || current.isEmpty || !ids.contains(current)) {
      final next = children.first.id;
      setState(() => _selectedChildId = next);
      _cubit.load(childId: next);
    }
  }

  VaccineStatus _mapStatus({
    required String status,
    required DateTime dueDate,
    required DateTime? takenDate,
  }) {
    final s = status.toLowerCase();
    if (s == 'taken' || takenDate != null) return VaccineStatus.done;
    if (dueDate.isBefore(DateTime.now())) return VaccineStatus.delayed;
    return VaccineStatus.upcoming;
  }

  VaccineItem _mapScheduleToUi({
    required BuildContext context,
    required String childId,
    required ChildVaccinationScheduleItem item,
  }) {
    final due = item.dueDate;
    final taken = item.takenDate;
    return VaccineItem(
      childId: childId,
      vaccinationId: item.id,
      title: item.vaccine.name,
      description: item.vaccine.description,
      date: due,
      takenDate: taken,
      type: VaccineType.injection,
      status: _mapStatus(status: item.status, dueDate: due, takenDate: taken),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return MultiBlocProvider(
      providers: [
        BlocProvider<VaccinationScheduleCubit>.value(value: _cubit),
        BlocProvider<ParentProfileCubit>.value(value: _parentProfileCubit),
      ],
      child: BlocListener<ParentProfileCubit, ParentProfileState>(
        listener: (context, pState) => _ensureValidSelectedChild(pState),
        child: Scaffold(
          appBar: CustomAppBar(title: context.l10n.vaccinations, isDark: isDark),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChildSelectorHeader(
                    isDark: isDark,
                    selectedChildId: _selectedChildId,
                    pickerExpanded: _childPickerExpanded,
                    onChildSelected: (id) {
                      setState(() {
                        _selectedChildId = id;
                        _childPickerExpanded = false;
                      });
                      _cubit.load(childId: id);
                    },
                    onTogglePicker: () => setState(() {
                      _childPickerExpanded = !_childPickerExpanded;
                    }),
                    ageFromBirth: _ageFromBirth,
                  ),
                  SizedBox(height: 16.h),
                //تنبيه
                Padding(
                  padding: EdgeInsets.all(2.r),
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: isDark
                          ? AppColors.primary_500_dark
                          : AppColors.primary_500_light,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary_50_dark
                            : AppColors.primary_50_light,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius_sm,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/Icons/vaccine/warning_icon.svg',
                                colorFilter: ColorFilter.mode(
                                  isDark
                                      ? AppColors.icon_onLight_dark
                                      : AppColors.icon_onLight_light,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                context.l10n.warningTitle,
                                style: AppTextStyle.semibold16TextHeading(
                                  context,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.l10n.vaccineWarningDescription,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.medium12TextButtonOutlined(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //التطعيمات
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: BlocBuilder<VaccinationScheduleCubit, VaccinationScheduleState>(
                    builder: (context, state) {
                      if (state is VaccinationScheduleLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is VaccinationScheduleError) {
                        return Column(
                          children: [
                            Center(child: Text(state.message)),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 8.h,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<VaccinationScheduleCubit>()
                                      .load(childId: _selectedChildId),
                                  child: Text(context.l10n.retry),
                                ),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<VaccinationScheduleCubit>()
                                      .generateAndLoad(childId: _selectedChildId),
                                  child: Text(
                                    context.l10n.generateVaccinationSchedule,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      if (state is VaccinationScheduleInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is VaccinationScheduleLoaded) {
                        final items = state.items
                            .map(
                              (e) => _mapScheduleToUi(
                                context: context,
                                childId: state.childId,
                                item: e,
                              ),
                            )
                            .toList();
                        if (items.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () => context
                                    .read<VaccinationScheduleCubit>()
                                    .generateAndLoad(childId: _selectedChildId),
                                child: Text(
                                  context.l10n.generateVaccinationSchedule,
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...items.map((v) => VaccineItemWidget(item: v)),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
