import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/date_formatter.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/vaccinations/data/models/child_vaccination_schedule_model.dart';
import 'package:dana/features/vaccinations/presentation/cubit/vaccination_schedule_cubit.dart';
import 'package:dana/features/vaccinations/presentation/cubit/vaccination_schedule_state.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

ChildVaccinationScheduleItem? _nextPending(
  List<ChildVaccinationScheduleItem> items,
) {
  final pending = items.where((e) {
    final s = e.status.toLowerCase();
    if (s == 'taken' || e.takenDate != null) return false;
    return true;
  }).toList();
  pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return pending.isEmpty ? null : pending.first;
}

class NextVaccineCard extends StatelessWidget {
  const NextVaccineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocBuilder<GrowthCubit, GrowthState>(
      builder: (context, growth) {
        final childId = growth is GrowthLoaded ? growth.childId : null;

        return BlocBuilder<VaccinationScheduleCubit, VaccinationScheduleState>(
          builder: (context, vac) {
            String vaccineName = context.l10n.mmrVaccineName;
            String timeLine = '—';
            if (vac is VaccinationScheduleLoaded) {
              final next = _nextPending(vac.items);
              if (next != null) {
                vaccineName = next.vaccine.name;
                final due = DateTime(
                  next.dueDate.year,
                  next.dueDate.month,
                  next.dueDate.day,
                );
                final today = DateTime.now();
                final start = DateTime(today.year, today.month, today.day);
                final days = due.difference(start).inDays;
                timeLine = context.l10n.vaccineTimeInfo(
                  formatDate(context, next.dueDate),
                  days,
                );
              } else {
                vaccineName = context.l10n.vaccineTaken;
                timeLine = '';
              }
            } else if (vac is VaccinationScheduleLoading ||
                vac is VaccinationScheduleInitial) {
              vaccineName = '…';
              timeLine = '';
            } else if (vac is VaccinationScheduleError) {
              vaccineName = context.l10n.nextVaccineTitle;
              timeLine = vac.message;
            }

            return CustomFrame(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(end: 12.w),
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.warning_subtle_light,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.r),
                          child: SvgPicture.asset(
                            'assets/Icons/notification/vaccine_icon.svg',
                            colorFilter: const ColorFilter.mode(
                              AppColors.warning_default_light,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.nextVaccineTitle,
                              style: AppTextStyle.medium12WarningDefault(
                                context,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Text(
                                vaccineName,
                                style: AppTextStyle.bold12TextHeading(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (timeLine.isNotEmpty)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/Icons/child_profile/clock_icon.svg',
                                    width: 12.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      timeLine,
                                      style: AppTextStyle.medium8TextBody(
                                        context,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    height: 36.h,
                    color: Colors.transparent,
                    text: context.l10n.fullVaccinationRecord,
                    textStyle: AppTextStyle.semibold12TextButtonOutlined(
                      context,
                    ),
                    borderColor: isDark
                        ? AppColors.border_button_outlined_dark
                        : AppColors.border_button_outlined_light,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.vaccine,
                        arguments: childId,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
