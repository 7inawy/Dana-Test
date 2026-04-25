import 'package:dana/features/home/presentation/widgets/custom_line_chart.dart';
import 'package:dana/features/home/presentation/widgets/line_chart_details.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StatisticsChart extends StatelessWidget {
  final List<DateTime> xDates;
  final List<double> heightCm;
  final List<double> weightKg;
  final List<double> headCircumferenceCm;

  const StatisticsChart({
    super.key,
    this.xDates = const [],
    this.heightCm = const [],
    this.weightKg = const [],
    this.headCircumferenceCm = const [],
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width > 600 ? 248.h : 208.h,
          child: Padding(
            padding: EdgeInsets.only(
              right: 14.33.w,
              left: 10.w,
              top: 10.5.h,
              bottom: 12.h,
            ),
            child: CustomLineChart(
              isDark: isDark,
              xDates: xDates,
              heightCm: heightCm,
              weightKg: weightKg,
              headCircumferenceCm: headCircumferenceCm,
            ),
          ),
        ),
        LineChartDetails(isDark: isDark),
      ],
    );
  }
}
