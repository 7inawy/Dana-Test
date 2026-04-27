import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/vaccinations/data/models/vaccine_model.dart';
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

  @override
  void initState() {
    super.initState();
    _cubit = sl<VaccinationScheduleCubit>()..load(childId: widget.childId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.vaccinations, isDark: isDark),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                      .load(childId: widget.childId),
                                  child: const Text('إعادة المحاولة'),
                                ),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<VaccinationScheduleCubit>()
                                      .generateAndLoad(childId: widget.childId),
                                  child: const Text('إنشاء جدول التطعيمات'),
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
                        final catalogHeader = state.catalog.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'مرجع التطعيمات',
                                      style: AppTextStyle.semibold16TextHeading(
                                        context,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    ...state.catalog.map(
                                      (v) => Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              v.name,
                                              style:
                                                  AppTextStyle.medium12TextButtonOutlined(
                                                    context,
                                                  ),
                                            ),
                                            if (v.description.isNotEmpty) ...[
                                              SizedBox(height: 2.h),
                                              Text(
                                                v.description,
                                                style:
                                                    AppTextStyle.medium12TextButtonOutlined(
                                                      context,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();

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
                              catalogHeader,
                              ElevatedButton(
                                onPressed: () => context
                                    .read<VaccinationScheduleCubit>()
                                    .generateAndLoad(childId: widget.childId),
                                child: const Text('إنشاء جدول التطعيمات'),
                              ),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            catalogHeader,
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
    );
  }
}
