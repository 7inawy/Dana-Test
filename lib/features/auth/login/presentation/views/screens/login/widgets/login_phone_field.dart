import 'package:dana/core/widgets/custom_Phone%20Field.dart';
import 'package:flutter/material.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_in_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPhoneField extends StatefulWidget {
  const LoginPhoneField({super.key});

  @override
  State<LoginPhoneField> createState() => _LoginPhoneFieldState();
}

class _LoginPhoneFieldState extends State<LoginPhoneField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPhoneField(
      controller: _controller,
      onNormalizedNumberChanged: (n) =>
          context.read<SignInCubit>().updatePhone(n),
    );
  }
}
