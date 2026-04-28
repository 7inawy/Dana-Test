import 'package:dana/core/utils/app_raduis.dart';

import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import '../widgets/child_info_body.dart';

///ضيف اولادك
class ChildInfoScreen extends StatefulWidget {
  static const String routeName = 'ChildInfoScreen';
  final VoidCallback? onNext;

  const ChildInfoScreen({super.key, required this.onNext});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  int selectedIndex = 1;

  final _childName = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _bloodType;

  @override
  void dispose() {
    _childName.dispose();
    super.dispose();
  }

  String _birthDateIso(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  void _onNext() {
    if (_bloodType == null || _bloodType!.trim().isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.bloodTypeHint),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final cubit = context.read<SignUpCubit>();
    cubit.updateChildName(_childName.text);
    final bd = _selectedBirthDate;
    cubit.updateChildBirthDate(bd != null ? _birthDateIso(bd) : '');
    cubit.updateChildGender(selectedIndex == 2 ? 'female' : 'male');
    final ok = cubit.onStep2Next();
    if (!ok) return;
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppRadius.space_xl),
        child: CustomElevatedButton(
          onTap: _onNext,
          icon: Icons.arrow_forward_ios,
          text: context.l10n.next,
        ),
      ),
      body: SafeArea(
        child: ChildInfoBody(
          selectedIndex: selectedIndex,
          onGenderSelect: (i) => setState(() => selectedIndex = i),
          childNameController: _childName,
          onBirthDateChanged: (d) => _selectedBirthDate = d,
          onBloodTypeChanged: (v) => _bloodType = v,
        ),
      ),
    );
  }
}
