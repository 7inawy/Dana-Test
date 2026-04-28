import 'package:flutter/cupertino.dart';

import '../../../../../../../core/utils/app_text_style.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';

class DoctorInfo extends StatelessWidget {
  final Doctor doctor;

  const DoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(doctor.name, style: AppTextStyle.semibold20TextHeading(context)),
        Text(doctor.specialty, style: AppTextStyle.medium12TextBody(context)),
      ],
    );
  }
}
