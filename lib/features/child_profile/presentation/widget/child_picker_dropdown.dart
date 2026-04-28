import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/presentation/widget/child_info_card_helpers.dart';
import 'package:dana/features/child_profile/presentation/widget/child_profile_avatar.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildPickerDropdown extends StatelessWidget {
  final List<ParentChildModel> otherChildren;
  final bool isDark;
  final ValueChanged<String> onSelectChild;

  const ChildPickerDropdown({
    super.key,
    required this.otherChildren,
    required this.isDark,
    required this.onSelectChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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
                onTap: () => onSelectChild(otherChildren[i].id),
                borderRadius: i == 0
                    ? BorderRadius.vertical(
                        top: Radius.circular(AppRadius.radius_md),
                      )
                    : i == otherChildren.length - 1
                    ? BorderRadius.vertical(
                        bottom: Radius.circular(AppRadius.radius_md),
                      )
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      childProfileAvatar(
                        isGirl:
                            otherChildren[i].gender.toLowerCase() == 'female',
                        profileUrl: otherChildren[i].profileImageUrl,
                        side: 44.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otherChildren[i].childName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.semibold16TextHeading(
                                context,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              context.formatAge(
                                ageFromBirth(otherChildren[i].birthDate).$1,
                                ageFromBirth(otherChildren[i].birthDate).$2,
                              ),
                              style: AppTextStyle.medium12TextBody(context),
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
    );
  }
}
