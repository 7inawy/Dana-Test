import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/currency_helper.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/logic/appointment_controller.dart';
import 'package:dana/features/Chat_bot/presentation/controller/data/model/message_model.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  final String? image;
  const DoctorCard({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final controller = context.watch<AppointmentController>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final name = controller.doctorName.isNotEmpty
        ? controller.doctorName
        : 'إسلام غنيم';
    final spec = controller.specialty.isNotEmpty
        ? controller.specialty
        : context.l10n.physiotherapist;
    final loc = controller.locationLine.isNotEmpty
        ? controller.locationLine
        : 'القاهرة – مصر الجديدة';
    final price = controller.detectionPrice > 0
        ? controller.detectionPrice
        : 250;

    return Container(
      height: 112.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
          width: 0.8.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.l10n.dr} $name',
                    style: AppTextStyle.semibold20TextHeading(context),
                  ),
                  SizedBox(height: 8.h),
                  Text(spec, style: AppTextStyle.bold12TextBody(context)),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: isDark
                            ? AppColors.icon_onLight_dark
                            : AppColors.icon_onLight_light,
                      ),
                      Expanded(
                        child: Text(
                          loc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bold12TextBody(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatDoctor,
                      arguments: Doctor(
                        id: controller.doctorId,
                        name: name,
                        specialty: spec,
                        location: loc,
                        imageUrl: controller.imageUrl,
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: isDark
                        ? AppColors.button_primary_default_dark
                        : AppColors.button_primary_default_light,
                    child: SvgPicture.asset(
                      'assets/Icons/messages.svg',
                      width: 22.w,
                      height: 22.h,
                      colorFilter: ColorFilter.mode(
                        isDark
                            ? AppColors.icon_onDark_dark
                            : AppColors.icon_onDark_light,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Text(
                  CurrencyHelper.format(context, price),
                  style: AppTextStyle.bold16TextBody(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
