import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/display_name_utils.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildSelectorHeader extends StatelessWidget {
  final bool isDark;
  final String? selectedChildId;
  final bool pickerExpanded;
  final ValueChanged<String> onChildSelected;
  final VoidCallback onTogglePicker;
  final (int, int) Function(DateTime?) ageFromBirth;

  const ChildSelectorHeader({
    super.key,
    required this.isDark,
    required this.selectedChildId,
    required this.pickerExpanded,
    required this.onChildSelected,
    required this.onTogglePicker,
    required this.ageFromBirth,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentProfileCubit, ParentProfileState>(
      builder: (context, pState) {
        // ── No children ──────────────────────────────────────────────
        if (pState is ParentProfileLoaded && pState.profile.children.isEmpty) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/Images/home/boy_child_photo.png',
                width: 48.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.5.h),
                  child: Text(
                    DisplayNameUtils.dedupeRepeatedPhrase(
                      pState.profile.parentName,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semibold16TextHeading(context),
                  ),
                ),
              ),
              CustomButton(
                borderRadius: AppRadius.radius_full,
                height: 32.w,
                width: 32.w,
                icon: Icons.arrow_forward_ios_rounded,
                iconSize: 14.w,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.addChildDesc)),
                  );
                },
              ),
            ],
          );
        }

        // ── Has children ─────────────────────────────────────────────
        if (pState is ParentProfileLoaded &&
            pState.profile.children.isNotEmpty) {
          final children = pState.profile.children;
          final resolvedId = selectedChildId ?? children.first.id;
          final ParentChildModel c = children.firstWhere(
            (e) => e.id == resolvedId,
            orElse: () => children.first,
          );
          final age = ageFromBirth(c.birthDate);
          final isBoy = c.gender.toLowerCase() != 'female';
          final showPicker = children.length > 1;
          final otherChildren = children
              .where((ch) => ch.id != c.id)
              .toList(growable: false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    isBoy
                        ? 'assets/Images/home/boy_child_photo.png'
                        : 'assets/Images/girl_child_photo.png',
                    width: 48.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.5.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  DisplayNameUtils.dedupeRepeatedPhrase(
                                    c.childName,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.semibold16TextHeading(
                                    context,
                                  ),
                                ),
                              ),
                              if (showPicker)
                                Container(
                                  margin: EdgeInsetsDirectional.only(
                                    start: 4.w,
                                  ),
                                  width: 20.w,
                                  height: 20.h,
                                  child: IconButton(
                                    onPressed: onTogglePicker,
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsetsDirectional.only(
                                      start: 4.w,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 20.w,
                                      minHeight: 20.h,
                                    ),
                                    icon: Icon(
                                      pickerExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: isDark
                                          ? AppColors.icon_onLight_dark
                                          : AppColors.icon_onLight_light,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.formatAge(age.$1, age.$2),
                            style: AppTextStyle.medium12TextBody(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    borderRadius: AppRadius.radius_full,
                    height: 32.w,
                    width: 32.w,
                    icon: Icons.arrow_forward_ios_rounded,
                    iconSize: 14.w,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(
                            AppRoutes.childProfile,
                            arguments: ChildProfileArgs.fromParentChild(c),
                          )
                          .then((_) {
                            if (context.mounted) {
                              context.read<GrowthCubit>().load(childId: c.id);
                            }
                          });
                    },
                  ),
                ],
              ),
              // ── Dropdown picker ──────────────────────────────────
              if (showPicker && pickerExpanded && otherChildren.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
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
                            onTap: () => onChildSelected(otherChildren[i].id),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    otherChildren[i].gender.toLowerCase() ==
                                            'female'
                                        ? 'assets/Images/girl_child_photo.png'
                                        : 'assets/Images/home/boy_child_photo.png',
                                    width: 44.w,
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
                                            ageFromBirth(
                                              otherChildren[i].birthDate,
                                            ).$1,
                                            ageFromBirth(
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
            ],
          );
        }

        // ── Error ─────────────────────────────────────────────────────
        if (pState is ParentProfileError) {
          return Row(
            children: [
              Image.asset(
                'assets/Images/home/boy_child_photo.png',
                width: 48.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  pState.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium12TextBody(context),
                ),
              ),
            ],
          );
        }

        // ── Loading ───────────────────────────────────────────────────
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/Images/home/boy_child_photo.png', width: 48.w),
            SizedBox(width: 12.w),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
