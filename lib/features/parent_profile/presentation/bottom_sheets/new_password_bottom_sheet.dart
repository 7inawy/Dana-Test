// import 'package:dana/core/utils/app_text_style.dart';
// import 'package:dana/core/widgets/custom_button.dart';
// import 'package:dana/core/widgets/password_field.dart';
// import 'package:dana/core/widgets/home_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class NewPasswordBottomSheet extends StatelessWidget {
//   const NewPasswordBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 24.w,
//         right: 24.w,
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(child: HomeIndicator()),
//               SizedBox(height: 24.h),
//               Text(
//                 'غير كلمة السر',
//                 style: AppTextStyle.medium20TextDisplay(context),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 'خليها سهلة عليك وماتتنسيش، بس في نفس الوقت قوية تحافظ على أمان حسابك.',
//                 style: AppTextStyle.regular16TextBody(context),
//               ),
//               SizedBox(height: 36.h),
//               Text(
//                 'كلمة المرور الجديدة',
//                 style: AppTextStyle.medium12TextHeading(context),
//               ),
//               SizedBox(height: 8.h),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 16.h),
//                 child: PasswordField(text: 'أدخل كلمة مرور قوية'),
//               ),
//               Text(
//                 'تأكيد كلمة المرور',
//                 style: AppTextStyle.medium12TextHeading(context),
//               ),
//               SizedBox(height: 8.h),
//               PasswordField(text: 'أكتب كلمة المرور مره أخري'),
//               Padding(
//                 padding: EdgeInsets.only(top: 137.h),
//                 child: CustomButton(text: 'تأكيد كلمة المرور', onTap: () {}),
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
