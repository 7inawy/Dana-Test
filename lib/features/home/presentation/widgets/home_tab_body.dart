import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_cubit.dart';
import 'package:dana/features/home/presentation/widgets/home_quick_access.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:dana/features/home/presentation/widgets/child_selector_header.dart';
import 'package:dana/features/home/presentation/widgets/home_doctors_section.dart';
import 'package:dana/features/home/presentation/widgets/home_growth_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabBody extends StatelessWidget {
  final bool isDark;
  final ParentProfileCubit parentProfileCubit;
  final DoctorsListCubit doctorsListCubit;
  final GrowthCubit growthCubit;
  final String? selectedChildId;
  final bool childPickerExpanded;
  final ValueChanged<String> onChildSelected;
  final VoidCallback onTogglePicker;
  final (int, int) Function(DateTime?) ageFromBirth;
  final void Function(String? childId) ensureGrowthLoaded;

  const HomeTabBody({
    super.key,
    required this.isDark,
    required this.parentProfileCubit,
    required this.doctorsListCubit,
    required this.growthCubit,
    required this.selectedChildId,
    required this.childPickerExpanded,
    required this.onChildSelected,
    required this.onTogglePicker,
    required this.ageFromBirth,
    required this.ensureGrowthLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParentProfileCubit>.value(value: parentProfileCubit),
        BlocProvider<DoctorsListCubit>.value(value: doctorsListCubit),
        BlocProvider<GrowthCubit>.value(value: growthCubit),
      ],
      child: BlocListener<ParentProfileCubit, ParentProfileState>(
        listener: (context, pState) {
          if (pState is ParentProfileLoaded &&
              pState.profile.children.isNotEmpty) {
            final ids = pState.profile.children.map((e) => e.id).toSet();
            var id = selectedChildId;
            if (id == null || !ids.contains(id)) {
              id = pState.profile.children.first.id;
              onChildSelected(id);
            }
            ensureGrowthLoaded(id);
          } else if (pState is ParentProfileLoaded &&
              pState.profile.children.isEmpty) {
            onChildSelected('');
          }
        },
        child: Stack(
          children: [
            // Coloured header band
            Container(
              color: isDark
                  ? AppColors.primary_600_dark
                  : AppColors.primary_600_light,
              height: 124.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ListView(
                children: [
                  // Statistics frame
                  CustomFrame(
                    child: Column(
                      children: [
                        ChildSelectorHeader(
                          isDark: isDark,
                          selectedChildId: selectedChildId,
                          pickerExpanded: childPickerExpanded,
                          onChildSelected: onChildSelected,
                          onTogglePicker: onTogglePicker,
                          ageFromBirth: ageFromBirth,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: const HomeGrowthChart(),
                        ),
                      ],
                    ),
                  ),
                  // Quick access
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.quickAccess,
                          style: AppTextStyle.medium16TextHeading(context),
                        ),
                        SizedBox(height: 12.h),
                        HomeQuickAccess(context: context, isDark: isDark),
                      ],
                    ),
                  ),
                  // Doctors section
                  const HomeDoctorsSection(),
                  SizedBox(height: 38.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
