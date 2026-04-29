import 'package:dana/core/widgets/text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/currency_helper.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentDetailsSection extends StatelessWidget {
  final bool isDark;

  const PaymentDetailsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final feeLabel = CurrencyHelper.format(context, 250);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.paymentDetailsTitle,
          style: AppTextStyle.bold16TextDisplay(context),
        ),
        SizedBox(height: 12.h),
        TextFrame(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.serviceCost,
                    style: AppTextStyle.bold12TextHeading(context),
                  ),
                  Text(feeLabel, style: AppTextStyle.bold12TextHeading(context)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.tax,
                    style: AppTextStyle.semibold12TextBody(context),
                  ),
                  Text(
                    CurrencyHelper.format(context, 0),
                    style: AppTextStyle.semibold12TextBody(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        TextFrame(
          color: isDark
              ? AppColors.bg_button_primary_disabled_dark
              : AppColors.bg_button_primary_disabled_light,
          borderColor: isDark
              ? AppColors.border_button_primary_dark
              : AppColors.border_button_primary_light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalCost,
                style: AppTextStyle.bold12TextDisplay(context),
              ),
              Text(
                feeLabel,
                style: AppTextStyle.semibold12TextDisplay(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
