import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/features/auth/signUp/presentation/views/screens/Personal_Information/views/widgets/personal_information_actions.dart';
import 'package:dana/features/auth/signUp/presentation/views/screens/Personal_Information/views/widgets/personal_information_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';

class PersonalInformationBody extends StatefulWidget {
  final VoidCallback? onNext;

  const PersonalInformationBody({super.key, required this.onNext});

  @override
  State<PersonalInformationBody> createState() =>
      _PersonalInformationBodyState();
}

class _PersonalInformationBodyState extends State<PersonalInformationBody> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  String? _government;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  void _onNext() {
    final cubit = context.read<SignUpCubit>();
    cubit.updateParentName(_name.text);
    cubit.updateGovernment(_government ?? '');
    cubit.updateAddress(_address.text);
    final ok = cubit.onStep1Next();
    if (!ok) return;
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h48),
            CustomScreenHeader(
              title: AppLocalizations.of(context)!.personalInfoTitle,
              subtitle: AppLocalizations.of(context)!.personalInfoDesc,
            ),
            SizedBox(height: AppSizes.h32),
            PersonalInformationFormFields(
              nameController: _name,
              addressController: _address,
              government: _government,
              onGovernmentChanged: (v) => setState(() => _government = v),
            ),
            SizedBox(height: AppSizes.h48),
            PersonalInformationActions(onNext: _onNext),
            SizedBox(height: AppSizes.h24),
          ],
        ),
      ),
    );
  }
}
