import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsWidget extends StatelessWidget {
  const DoctorDetailsWidget({super.key, this.doctor});

  final BookingDoctorArgs? doctor;

  @override
  Widget build(BuildContext context) {
    final name = doctor?.doctorName.trim() ?? '';
    final spec = doctor?.specialty.trim() ?? '';
    final loc = doctor?.locationLine.trim() ?? '';
    const fallback = 'assets/Images/home/doctor1.png';
    final img = doctor?.imageUrl ?? fallback;

    Widget avatar() {
      if (img.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            img,
            height: 70.h,
            width: 70.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              fallback,
              height: 70.h,
              width: 70.w,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.asset(img, height: 70.h, width: 70.w, fit: BoxFit.cover),
      );
    }

    return Row(
      children: [
        avatar(),
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
                    color: AppColors.icon_onLight_light,
                    size: 16.r,
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
      ],
    );
  }
}
