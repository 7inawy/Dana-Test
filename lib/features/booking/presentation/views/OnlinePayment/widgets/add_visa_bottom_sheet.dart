import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/extensions/localization_extension.dart';
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
  static const int _kCardNumberLen = 16;
  static const int _kCvvLen = 3;
  static const int _kExpiryMaxLen = 5; // MM/YY
  static const double _kSheetTopPadding = 32;
  static const double _kSheetHorizontalPadding = 24;
  static const double _kLabelToFieldSpacing = 8;
  static const double _kSectionSpacing = 16;
  static const double _kSubmitTopSpacing = 39;
  static const double _kEncryptedNoticeTopSpacing = 8;
  static const double _kEncryptedNoticeBottomSpacing = 12;
  static const double _kCvvFieldWidth = 142;
  static final RegExp _digitsOnly = RegExp(r'[0-9]');
  static final RegExp _cardNameAllowed = RegExp(r'[a-zA-Z\u0600-\u06FF\s]');

  final TextEditingController expiryController = TextEditingController();
  String cardNumber = '';
  String expiry = '';
  String cvv = '';
  String cardName = '';

  @override
  void dispose() {
    expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: _kSheetTopPadding.h,
        start: _kSheetHorizontalPadding.w,
        end: _kSheetHorizontalPadding.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomScreenHeader(
              title: context.l10n.addNewCardTitle,
              subtitle: context.l10n.addNewCardSubtitle,
            ),
            SizedBox(height: _kSheetTopPadding.h),
            Text(
              context.l10n.cardNumberLabel,
              style: AppTextStyle.bold12TextHeading(context),
            ),
            SizedBox(height: _kLabelToFieldSpacing.h),
            Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextField(
                hintText: context.l10n.cardNumberHint,
                inputType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(_digitsOnly),
                ],
                maxLength: _kCardNumberLen,
                onChange: (v) => cardNumber = v,
              ),
            ),
            SizedBox(height: _kSectionSpacing.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.expiryDateLabel,
                        style: AppTextStyle.bold12TextHeading(context),
                      ),
                      SizedBox(height: _kLabelToFieldSpacing.h),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          controller: expiryController,
                          hintText: 'MM/YY',
                          inputType: TextInputType.number,
                          maxLength: _kExpiryMaxLen,
                          onChange: (v) {
                            if (v.length == 2 && !v.contains('/')) {
                              expiryController.text = '$v/';
                              expiryController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: expiryController.text.length,
                                    ),
                                  );
                            }
                            if (expiryController.text.length == _kExpiryMaxLen) {
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
                SizedBox(width: _kLabelToFieldSpacing.h),

                SizedBox(
                  width: _kCvvFieldWidth.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.securityCodeLabel,
                        style: AppTextStyle.bold12TextHeading(context),
                      ),
                      SizedBox(height: _kLabelToFieldSpacing.h),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          inputType: TextInputType.number,
                          maxLength: _kCvvLen,
                          hintText: context.l10n.cvvHint,
                          onChange: (v) => cvv = v,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: _kSectionSpacing.h),
            Text(
              context.l10n.cardHolderNameLabel,
              style: AppTextStyle.bold12TextHeading(context),
            ),
            SizedBox(height: _kLabelToFieldSpacing.h),
            Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextField(
                hintText: context.l10n.cardHolderNameHint,
                inputType: TextInputType.name,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                    _cardNameAllowed,
                  ),
                ],
                onChange: (v) => cardName = v,
              ),
            ),
            SizedBox(height: _kSubmitTopSpacing.h),
            CustomButton(
              text: context.l10n.saveCard,
              onTap: () {
                if (cardNumber.length == _kCardNumberLen &&
                    expiry.isNotEmpty &&
                    cvv.length == _kCvvLen &&
                    cardName.isNotEmpty) {
                  widget.onSave({
                    'last4': cardNumber.substring(cardNumber.length - 4),
                    'expiry': expiry,
                  });
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: _kEncryptedNoticeTopSpacing.h),
            Center(
              child: Text(
                context.l10n.dataEncryptedNotice,
                style: AppTextStyle.bold12Secondary(context),
              ),
            ),
            SizedBox(height: _kEncryptedNoticeBottomSpacing.h),
          ],
        ),
      ),
    );
  }
}
