import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/notification/data/models/notification_model.dart';
import 'package:dana/features/notification/utils/notification_icon_helper.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 8.w),
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 8.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light)
              : (isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light),
          borderRadius: BorderRadius.circular(AppRadius.radius_md),
          border: Border.all(
            color: notification.isRead
                ? (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light)
                : (isDark
                      ? AppColors.primary_100_dark
                      : AppColors.primary_100_light),
            width: AppRadius.stroke_thin,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(end: 8.w),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.5.r),
                child: SvgPicture.asset(
                  NotificationIconHelper.getIconPath(notification.type),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: AppTextStyle.semibold12TextHeading(context),
                      ),
                      Text(
                        notification.time.format(context),
                        style: AppTextStyle.regular8TextBody(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: AppTextStyle.regular12TextHeading(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
