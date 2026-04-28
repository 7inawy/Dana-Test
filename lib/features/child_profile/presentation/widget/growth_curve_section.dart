import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/home/presentation/widgets/statistics_chart.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/child_profile/presentation/bottom_sheets/update_data_bottom_sheet.dart'
    show showUpdateMeasurementsBottomSheet;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/growth_record_model.dart';
import '../../domain/growth_monthly.dart';
import '../cubit/growth_cubit.dart';
import '../cubit/growth_state.dart';

class GrowthCurveSection extends StatelessWidget {
  const GrowthCurveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return CustomFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.growthCurveTitle,
            style: AppTextStyle.semibold16TextHeading(context),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: BlocBuilder<GrowthCubit, GrowthState>(
              builder: (context, state) {
                final List<GrowthRecord> records = state is GrowthLoaded
                    ? growthRecordsOnePerMonth(state.records)
                    : <GrowthRecord>[];
                final List<DateTime> xDates = records
                    .map((r) => r.recordDate)
                    .toList();
                final List<double> height = records
                    .map((r) => r.height)
                    .toList();
                final List<double> weight = records
                    .map((r) => r.weight)
                    .toList();
                final List<double> head = records
                    .map((r) => r.headCircumference)
                    .toList();
                if (state is GrowthLoaded && records.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: Image.asset(
                        'assets/Images/home/no_data.png',
                        width: 220.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }
                return StatisticsChart(
                  xDates: xDates,
                  heightCm: height,
                  weightKg: weight,
                  headCircumferenceCm: head,
                );
              },
            ),
          ),

          CustomTextFrame(
            text: '',
            vPadding: 10.h,
            hPadding: 8.w,
            backgroundColor: isDark
                ? AppColors.secondary_50_dark
                : AppColors.secondary_50_light,
            preIconSrc: 'assets/Icons/child_profile/data_icon.svg',
            sufIconSrc: 'assets/Icons/dark_arrow_back.svg',
            sufIconWidth: 20.w,
            preIconBackgroundColor: isDark
                ? AppColors.primary_50_dark
                : AppColors.primary_50_light,
            preIconColor: isDark
                ? const Color.fromARGB(255, 63, 157, 168)
                : AppColors.icon_onLight_light,
            preIconBorderRadius: AppRadius.radius_full,
            preIconPadding: 6.r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.updateData,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                Text(
                  context.l10n.updateChildMeasurements(
                    context.select((GrowthCubit c) {
                      final st = c.state;
                      return st is GrowthLoaded && st.childName.isNotEmpty
                          ? st.childName
                          : '';
                    }),
                  ),
                  style: AppTextStyle.bold12TextHeading(context),
                ),
              ],
            ),
            onTap: () => showUpdateMeasurementsBottomSheet(context),
          ),
        ],
      ),
    );
  }
}
