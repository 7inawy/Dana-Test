import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import '../widgets/contact_info_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';

class ContactInfoScreen extends StatefulWidget {
  static const String routeName = 'ContactInfoScreen';
  final VoidCallback? onNext;

  const ContactInfoScreen({super.key, required this.onNext});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final cubit = context.read<SignUpCubit>();
    cubit.updatePhone(_phoneController.text);
    cubit.updateEmail(_emailController.text);
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppRadius.space_xl),
        child: CustomElevatedButton(
          onTap: _onNextPressed,
          icon: Icons.arrow_forward_ios,
          text: context.l10n.getVerificationCode,
        ),
      ),
      body: SafeArea(
        child: ContactInfoBody(
          emailController: _emailController,
          phoneController: _phoneController,
        ),
      ),
    );
  }
}
