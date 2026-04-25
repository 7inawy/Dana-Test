import 'package:dana/features/child_profile/domain/growth_monthly.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/home/presentation/widgets/statistics_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeGrowthChart extends StatelessWidget {
  const HomeGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrowthCubit, GrowthState>(
      builder: (context, gState) {
        final chartHeight = MediaQuery.of(context).size.width > 600
            ? 248.h
            : 208.h;

        if (gState is GrowthLoading || gState is GrowthInitial) {
          return SizedBox(
            height: chartHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (gState is GrowthLoaded) {
          final sorted = growthRecordsOnePerMonth(gState.records);
          if (sorted.isEmpty) {
            return _EmptyChart(height: chartHeight);
          }
          return StatisticsChart(
            xDates: sorted.map((e) => e.recordDate).toList(),
            heightCm: sorted.map((e) => e.height).toList(),
            weightKg: sorted.map((e) => e.weight).toList(),
            headCircumferenceCm: sorted
                .map((e) => e.headCircumference)
                .toList(),
          );
        }

        return _EmptyChart(height: chartHeight);
      },
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final double height;
  const _EmptyChart({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Image.asset('assets/Images/exam_1.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
