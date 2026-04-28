import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/parent_profile/data/models/child_model.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

ImageProvider _childAvatarImage(ChildModel child) {
  final u = child.profileImageUrl;
  if (u != null && u.isNotEmpty && u.startsWith('http')) {
    return NetworkImage(u);
  }
  return AssetImage(
    child.gender == 1
        ? 'assets/Images/home/boy_child_photo.png'
        : 'assets/Images/girl_child_photo.png',
  );
}

class ChildCard extends StatelessWidget {
  final ChildModel child;

  const ChildCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: 119.w,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_surface_subtle_dark
            : AppColors.bg_surface_subtle_light,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
          width: AppRadius.stroke_thin,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: _childAvatarImage(child),
            ),
            SizedBox(height: 12.h),
            Text(
              child.name,
              style: AppTextStyle.semibold16TextHeading(context),
            ),
            SizedBox(height: 4.h),
            Text(
              context.formatAge(child.years, child.months),
              style: AppTextStyle.regular12TextBody(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
