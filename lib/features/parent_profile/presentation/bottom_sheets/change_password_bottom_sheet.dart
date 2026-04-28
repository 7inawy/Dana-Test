// import 'package:dana/Pages/otp_page.dart';
// import 'package:dana/core/widgets/custom_button.dart';
// import 'package:dana/core/widgets/phone_field.dart';
// import 'package:dana/core/utils/app_sizes.dart';
// import 'package:dana/core/utils/app_text_style.dart';
// import 'package:dana/core/widgets/home_indicator.dart';
// import 'package:dana/extensions/localization_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class ChangePasswordBottomSheet extends StatelessWidget {
//   const ChangePasswordBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 24.w,
//         right: 24.w,
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(child: HomeIndicator()),
//             Center(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 32.h, top: 24.h),
//                 child: SvgPicture.asset(
//                   'assets/Icons/forget_password.svg',
//                   width: 252.w,
//                   height: 258.h,
//                 ),
//               ),
//             ),
//             Text(
//               context.l10n.changePasswordTitle,
//               style: AppTextStyle.medium20TextDisplay(context),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               context.l10n.changePasswordDesc,
//               style: AppTextStyle.regular16TextBody(context),
//             ),
//             SizedBox(height: 32.h),
//             Text(
//               context.l10n.phoneNumberLabel,
//               style: AppTextStyle.medium12TextHeading(context),
//             ),
//             SizedBox(height: AppSizes.h8),
//             SizedBox(height: 64.h, child: PhoneField()),
//             SizedBox(height: 114.h),
//             CustomButton(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         const OtpPage(mode: OtpMode.changePassword),
//                   ),
//                 );
//               },
//               text: context.l10n.sendVerificationCode,
//               icon: Icons.arrow_forward_ios_rounded,
//             ),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
