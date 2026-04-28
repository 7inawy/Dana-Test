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

  Widget _buildAvatar(BuildContext context, String src) {
    final s = src.trim();
    const fallback = 'assets/Images/home/doctor1.png';
    Widget core(Widget child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(width: 70.w, height: 70.h, child: child),
      );
    }

    if (s.startsWith('http')) {
      return core(
        Image.network(
          s,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.asset(fallback, fit: BoxFit.cover),
        ),
      );
    }
    if (s.isNotEmpty && s.startsWith('assets/')) {
      return core(Image.asset(s, fit: BoxFit.cover));
    }
    return core(Image.asset(fallback, fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final controller = context.watch<AppointmentController>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final name = controller.doctorName.trim();
    final spec = controller.specialty.trim();
    final loc = controller.locationLine.trim();
    final price = controller.detectionPrice;
    final img = (image != null && image!.trim().isNotEmpty)
        ? image!.trim()
        : controller.imageUrl;

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
            _buildAvatar(context, img),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.l10n.dr} ${name.isEmpty ? '—' : name}',
                    style: AppTextStyle.semibold20TextHeading(context),
                  ),
                  SizedBox(height: 8.h),
                  if (spec.isNotEmpty)
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
                          loc.isEmpty ? '—' : loc,
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
                  price > 0 ? CurrencyHelper.format(context, price) : '—',
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
