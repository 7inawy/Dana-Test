import 'package:flutter/material.dart';
import '../widgets/personal_information_body.dart';

///خلينا نتعرف عليك page=>

class PersonalInformation extends StatelessWidget {
  static const String routeName = 'PersonalInformation';
  final VoidCallback? onNext;

  const PersonalInformation({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: PersonalInformationBody(onNext: onNext)),
    );
  }
}
