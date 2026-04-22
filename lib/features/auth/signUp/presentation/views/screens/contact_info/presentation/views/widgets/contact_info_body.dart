import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/core/widgets/phone_field.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/Custom_indicator.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactInfoBody extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const ContactInfoBody({
    super.key,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: CustomIndicatorRow(currentIndex: 2, itemCount: 4),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.h24),
                  CustomScreenHeader(
                    title: context.l10n.howCanWeReachYou,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.howCanWeReachYouHint,
                  ),
                  SizedBox(height: AppSizes.h32),
                  Text(
                    context.l10n.phoneNumber,
                    style: AppTextStyle.medium12TextHeading(context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.h8),
                    child: SizedBox(
                      height: 64.h,
                      child: PhoneField(controller: phoneController),
                    ),
                  ),
                  Text(
                    context.l10n.email,
                    style: AppTextStyle.medium12TextHeading(context),
                  ),
                  SizedBox(height: AppSizes.h8),
                  CustomTextField(
                    hintText: context.l10n.enterEmail,
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
