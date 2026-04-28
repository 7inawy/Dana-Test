import 'package:flutter/material.dart';

import '../../../Personal_Information/views/screens/personal_information.dart';
import '../../../add_children/views/screens/child_info_screen.dart';
import '../../../contact_info/presentation/views/screens/contant_Info_screen.dart';
import '../../../create_password/views/screens/create_password_screen.dart';

class SignUpPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;

  const SignUpPageView({
    super.key,
    required this.controller,
    required this.onPageChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: onPageChanged,
      children: [
        PersonalInformation(onNext: onNext),
        ChildInfoScreen(onNext: onNext),
        ContactInfoScreen(onNext: onNext),
        CreatePasswordScreen(onNext: onNext),
      ],
    );
  }
}
