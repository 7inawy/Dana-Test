import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import '../widgets/contact_info_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';

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

  Future<void> _onNextPressed() async {
    final cubit = context.read<SignUpCubit>();
    cubit.updatePhone(_phoneController.text);
    cubit.updateEmail(_emailController.text);
    if (!cubit.onStep3Next()) return;
    await cubit.preSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppRadius.space_xl),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (p, n) =>
              n is SignUpLoading || p is SignUpLoading,
          builder: (context, state) {
            final loading = state is SignUpLoading;
            return CustomElevatedButton(
              onTap: _onNextPressed,
              isDisabled: loading,
              icon: Icons.arrow_forward_ios,
              text: context.l10n.getVerificationCode,
            );
          },
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
