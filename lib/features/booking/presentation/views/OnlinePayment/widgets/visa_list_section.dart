import 'package:dana/core/widgets/text_frame.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/widgets/visa_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisaListSection extends StatelessWidget {
  final List<Map<String, String>> visas;
  final int? selectedVisa;
  final bool isDark;
  final Function(int) onSelectVisa;
  final VoidCallback onAddVisa;

  const VisaListSection({
    super.key,
    required this.visas,
    required this.selectedVisa,
    required this.isDark,
    required this.onSelectVisa,
    required this.onAddVisa,
  });

  @override
  Widget build(BuildContext context) {
    return TextFrame(
      vPadding: 12,
      child: Column(
        children: [
          ...visas.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> visa = entry.value;
            return VisaCardItem(
              index: index,
              visa: visa,
              selectedVisa: selectedVisa,
              isDark: isDark,
              onTap: () => onSelectVisa(index),
            );
          }),
          GestureDetector(
            onTap: onAddVisa,
            child: Container(
              margin: EdgeInsets.only(top: 4.h),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/Images/plus.png',
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'إضافة بطاقة جديدة',
                      style: AppTextStyle.bold12TextBody(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
