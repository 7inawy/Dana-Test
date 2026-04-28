import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/presentation/widget/child_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildInfoHeaderRow extends StatelessWidget {
  final String displayName;
  final String ageText;
  final bool isGirl;
  final bool isDark;
  final bool showChildPicker;
  final bool pickerExpanded;
  final String? profileUrl;
  final VoidCallback? onPickerToggle;
  final VoidCallback? onCameraTap;

  const ChildInfoHeaderRow({
    super.key,
    required this.displayName,
    required this.ageText,
    required this.isGirl,
    required this.isDark,
    required this.showChildPicker,
    required this.pickerExpanded,
    this.profileUrl,
    this.onPickerToggle,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar + camera button
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          childProfileAvatar(
                            isGirl: isGirl,
                            profileUrl: profileUrl,
                            side: 48.w,
                          ),
                          if (onCameraTap != null)
                            PositionedDirectional(
                              end: -2.w,
                              bottom: -2.h,
                              child: Material(
                                color: isDark
                                    ? AppColors.primary_default_dark
                                    : AppColors.primary_default_light,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: onCameraTap,
                                  child: Padding(
                                    padding: EdgeInsets.all(6.r),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 14.r,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Name + age + badges
                      Expanded(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(start: 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    displayName.isEmpty ? '…' : displayName,
                                    style: AppTextStyle.semibold16TextHeading(
                                      context,
                                    ),
                                  ),
                                  if (showChildPicker)
                                    Container(
                                      width: 20.w,
                                      height: 20.h,
                                      margin: EdgeInsetsDirectional.only(
                                        end: 4.w,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          onPressed: onPickerToggle,
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsetsDirectional.only(
                                            start: 4.w,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 20.w,
                                            minHeight: 20.h,
                                          ),
                                          icon: Container(
                                            width: 20.w,
                                            height: 20.h,
                                            margin: EdgeInsetsDirectional.only(
                                              end: 4.w,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                pickerExpanded
                                                    ? Icons.expand_less
                                                    : Icons.expand_more,
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
                                  else if (onCameraTap == null)
                                    Icon(
                                      Icons.info_outline,
                                      size: 20.w,
                                      color: isDark
                                          ? AppColors.icon_onLight_dark
                                          : AppColors.icon_onLight_light,
                                    )
                                  else
                                    SizedBox(width: 4.w),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                ageText.isEmpty ? '—' : ageText,
                                style: AppTextStyle.medium12TextBody(context),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  children: [
                                    // Gender badge
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
                                                  ? AppColors.primary_50_dark
                                                  : AppColors.primary_50_light),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.radius_full,
                                        ),
                                        border: Border.all(
                                          width: AppRadius.stroke_thin,
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
                                                    ? AppColors.primary_200_dark
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
                                    // Health badge
                                    Container(
                                      margin: EdgeInsetsDirectional.only(
                                        start: 8.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4.h,
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.bg_success_subtle_dark
                                            : AppColors.bg_success_subtle_light,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.radius_full,
                                        ),
                                        border: Border.all(
                                          width: AppRadius.stroke_thin,
                                          color: isDark
                                              ? AppColors.success_default_dark
                                              : AppColors.success_default_light,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.l10n.growthStatusHealthy,
                                          style: AppTextStyle.medium12Succes(
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
    );
  }
}
