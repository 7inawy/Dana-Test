import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    super.key,
    required this.isDark,
    required this.xDates,
    required this.heightCm,
    required this.weightKg,
    required this.headCircumferenceCm,
  });

  final bool isDark;
  final List<DateTime> xDates;
  final List<double> heightCm;
  final List<double> weightKg;
  final List<double> headCircumferenceCm;

  String _monthLabel(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(d.month - 1).clamp(0, 11)];
  }

  @override
  Widget build(BuildContext context) {
    final count = xDates.length;
    final heightSpots = List.generate(
      count,
      (i) => FlSpot(
        i.toDouble(),
        (i < heightCm.length ? heightCm[i] : 0).toDouble(),
      ),
    );
    final headSpots = List.generate(
      count,
      (i) => FlSpot(
        i.toDouble(),
        (i < headCircumferenceCm.length ? headCircumferenceCm[i] : 0)
            .toDouble(),
      ),
    );
    final weightSpots = List.generate(
      count,
      (i) => FlSpot(
        i.toDouble(),
        (i < weightKg.length ? weightKg[i] : 0).toDouble(),
      ),
    );

    final allY = [
      ...heightSpots.map((s) => s.y),
      ...headSpots.map((s) => s.y),
      ...weightSpots.map((s) => s.y),
    ];
    final maxY = allY.isEmpty
        ? 100.0
        : (allY.reduce((a, b) => a > b ? a : b) + 5);
    final minY = 0.0;

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,

        /// خطوط الشبكة
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              strokeWidth: 1.w,
              dashArray: [4, 4],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              strokeWidth: 1.w,
              dashArray: [4, 4],
            );
          },
        ),

        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 32.w,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Center(
                    child: Text(
                      value.toInt().toString(),
                      style: AppTextStyle.medium12TextBody(context),
                    ),
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: MediaQuery.of(context).size.width > 600
                  ? 27.h
                  : 22.h,
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= xDates.length) {
                  return const SizedBox();
                }

                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    _monthLabel(xDates[idx]),
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                );
              },
            ),
          ),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(
              width: 1.w,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
            bottom: BorderSide(
              width: 1.w,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
            top: BorderSide(
              width: 0.2.w,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
            right: BorderSide(
              width: 0.2.w,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: weightSpots,
            barWidth: 2,
            color: isDark
                ? const Color.fromARGB(255, 63, 157, 168)
                : AppColors.primary_default_light,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: headSpots,
            barWidth: 2,
            color: isDark
                ? AppColors.icon_onLight_dark
                : AppColors.icon_onLight_light,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: heightSpots,
            barWidth: 2,
            color: isDark
                ? AppColors.secondary_default_dark
                : AppColors.secondary_default_light,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
