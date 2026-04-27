import 'package:dana/core/constant/governorates.dart';
import 'package:dana/core/utils/parent_phone_utils.dart';
import 'package:dana/core/widgets/animated_dropdown.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/core/widgets/custom_Phone%20Field.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key, required this.initial});

  final ParentProfileModel initial;

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  String? _governorate;
  String _phoneForApi = '';
  bool _saving = false;

  List<String> get _govItems {
    final g = widget.initial.government.trim();
    if (g.isEmpty) return Governorates.egypt;
    if (Governorates.egypt.contains(g)) return Governorates.egypt;
    return [...Governorates.egypt, g];
  }

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nameCtrl = TextEditingController(text: p.parentName);
    _emailCtrl = TextEditingController(text: p.email);
    _addressCtrl = TextEditingController(text: p.address);
    _phoneCtrl = TextEditingController(text: p.phone);
    _phoneForApi = ParentPhoneUtils.normalizeForApi(p.phone);
    final gov = p.government.trim();
    _governorate = gov.isNotEmpty && _govItems.contains(gov)
        ? gov
        : _govItems.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    final gov = _governorate ?? _govItems.first;
    setState(() => _saving = true);
    final err = await context.read<ParentProfileCubit>().updateProfile(
      parentName: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneForApi.isNotEmpty
          ? _phoneForApi
          : ParentPhoneUtils.normalizeForApi(_phoneCtrl.text),
      government: gov,
      address: _addressCtrl.text,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (err == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.done)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentProfileCubit, ParentProfileState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: HomeIndicator()),
                SizedBox(height: 20.h),
                Text(
                  context.l10n.editProfileTitle,
                  style: AppTextStyle.medium20TextDisplay(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.l10n.editProfileDesc,
                  style: AppTextStyle.regular16TextBody(context),
                ),
                SizedBox(height: 24.h),
                Text(
                  context.l10n.fullNameLabel,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _nameCtrl,
                  hintText: context.l10n.fullNameHint,
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.governorateLabel,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                AnimatedDropdown(
                  hintText: context.l10n.governorateHint,
                  items: _govItems,
                  value: _governorate,
                  onChanged: (val) {
                    setState(() => _governorate = val);
                  },
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.addressLabel,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _addressCtrl,
                  hintText: context.l10n.addressHint,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 64.h,
                  child: CustomPhoneField(
                    controller: _phoneCtrl,
                    onNormalizedNumberChanged: (n) =>
                        setState(() => _phoneForApi = n),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.accountLabel,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _emailCtrl,
                  hintText: context.l10n.accountHint,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: _saving ? '…' : context.l10n.editData,
                  onTap: _saving || state is ParentProfileLoading
                      ? () {}
                      : () => _save(context),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
