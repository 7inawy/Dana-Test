import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddVisaBottomSheet extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const AddVisaBottomSheet({super.key, required this.onSave});

  @override
  State<AddVisaBottomSheet> createState() => _AddVisaBottomSheetState();
}

class _AddVisaBottomSheetState extends State<AddVisaBottomSheet> {
  final TextEditingController expiryController = TextEditingController();
  String cardNumber = '';
  String expiry = '';
  String cvv = '';
  String cardName = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 32.h,
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomScreenHeader(
              title: 'إضافة بطاقة جديدة',
              subtitle: 'ادخل بيانات بطاقتك لإتمام الدفع بأمان.',
            ),
            SizedBox(height: 32.h),
            Text('رقم البطاقة', style: AppTextStyle.bold12TextHeading(context)),
            SizedBox(height: 8.h),
            Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextField(
                hintText: '0000 0000 0000 0000',
                inputType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                maxLength: 16,
                onChange: (v) => cardNumber = v,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ الانتهاء',
                        style: AppTextStyle.bold12TextHeading(context),
                      ),
                      SizedBox(height: 8.h),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          controller: expiryController,
                          hintText: "MM/YY",
                          inputType: TextInputType.number,
                          maxLength: 5,
                          onChange: (v) {
                            if (v.length == 2 && !v.contains('/')) {
                              expiryController.text = "$v/";
                              expiryController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: expiryController.text.length,
                                    ),
                                  );
                            }
                            if (expiryController.text.length == 5) {
                              final month = int.tryParse(
                                expiryController.text.substring(0, 2),
                              );
                              final year = int.tryParse(
                                expiryController.text.substring(3, 5),
                              );
                              if (month == null || month < 1 || month > 12) {
                                expiry = '';
                              } else if (year == null) {
                                expiry = '';
                              } else {
                                expiry = expiryController.text;
                              }
                            } else {
                              expiry = '';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.h),

                SizedBox(
                  width: 142.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رمز الأمان',
                        style: AppTextStyle.bold12TextHeading(context),
                      ),
                      SizedBox(height: 8.h),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          inputType: TextInputType.number,
                          maxLength: 3,
                          hintText: 'CVV',
                          onChange: (v) => cvv = v,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'اسم صاحب البطاقة',
              style: AppTextStyle.bold12TextHeading(context),
            ),
            SizedBox(height: 8.h),
            Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextField(
                hintText: 'اكتب الاسم كما هو على البطاقة',
                inputType: TextInputType.name,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                  ),
                ],
                onChange: (v) => cardName = v,
              ),
            ),
            SizedBox(height: 39.h),
            CustomButton(
              text: 'حفظ البطاقة',
              onTap: () {
                if (cardNumber.length == 16 &&
                    expiry.isNotEmpty &&
                    cvv.length == 3 &&
                    cardName.isNotEmpty) {
                  widget.onSave({
                    'last4': cardNumber.substring(cardNumber.length - 4),
                    'expiry': expiry,
                  });
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                'بياناتك مشفرة ومحميّة بالكامل.',
                style: AppTextStyle.bold12Secondary(context),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
