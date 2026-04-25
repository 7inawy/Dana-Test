import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineChartDetails extends StatelessWidget {
  const LineChartDetails({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 5.h,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(end: 8.w),
              width: 12.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.secondary_default_dark
                    : AppColors.secondary_default_light,
                borderRadius: BorderRadius.circular(AppRadius.radius_full),
              ),
            ),
            Text(
              '${context.l10n.height} (${context.l10n.cm})',
              style: AppTextStyle.regular12TextBody(context),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(end: 8.w),
              width: 12.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.icon_onLight_dark
                    : AppColors.icon_onLight_light,
                borderRadius: BorderRadius.circular(AppRadius.radius_full),
              ),
            ),
            Text(
              '${context.l10n.headCircumference} (${context.l10n.cm})',
              style: AppTextStyle.regular12TextBody(context),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              margin: EdgeInsetsDirectional.only(end: 8.w),
              width: 12.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 63, 157, 168)
                    : AppColors.primary_default_light,
                borderRadius: BorderRadius.circular(AppRadius.radius_full),
              ),
            ),
            Text(
              '${context.l10n.weight} (${context.l10n.kg})',
              style: AppTextStyle.regular12TextBody(context),
            ),
          ],
        ),
      ],
    );
  }
}
