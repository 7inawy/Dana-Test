import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/animated_dropdown.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/widgets/custom_toggle_selector.dart';
import 'package:dana/core/widgets/selectable_option.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/presentation/cubit/payment_children_cubit.dart';
import 'package:dana/features/booking/presentation/cubit/payment_children_state.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/Online_Payment_Screen.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/Payment_Confirm_Screen.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  static const String routeName = 'PaymentMethodScreen';

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  static const double _kScreenTopPadding = 32;
  static const double _kScreenHorizontalPadding = 24;
  static const double _kBottomBarPadding = 24;
  static const double _kHeaderButtonSize = 36;

  static const double _kSectionGapLg = 24;
  static const double _kSectionGapMd = 16;
  static const double _kSectionGapSm = 12;
  static const double _kPatientDropdownHeight = 48;
  static const double _kNoteFieldHeight = 85;
  static const double _kNoteFieldPadding = 16;
  static const double _kLoadingVerticalPadding = 16;

  static const String _kEmptyDraftMessage =
      'لم يتم تحديد موعد. ارجع واختر التاريخ والوقت.';
  static const String _kNoChildrenMessage =
      'لا يوجد أطفال مسجّلين. أضف طفلاً من الملف الشخصي.';

  BookingDraft? _slotDraft;
  String? _childName;
  int? _selectedOption;

  final FocusNode _noteFocusNode = FocusNode();
  final TextEditingController _noteController = TextEditingController();
  bool _childrenLoadRequested = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final a = ModalRoute.of(context)?.settings.arguments;
    if (_slotDraft == null && a is BookingDraft) {
      _slotDraft = a;
      // Cubit is provided in build(); trigger load there.
    }
  }

  int _yearsOld(DateTime? birthDate) {
    if (birthDate == null) return 0;
    final n = DateTime.now();
    var y = n.year - birthDate.year;
    if (n.month < birthDate.month ||
        (n.month == birthDate.month && n.day < birthDate.day)) {
      y--;
    }
    return y < 0 ? 0 : y;
  }

  ParentChildModel? _childByName(List<ParentChildModel> children, String? name) {
    if (name == null) return null;
    for (final c in children) {
      if (c.childName == name) return c;
    }
    return null;
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocProvider(
      create: (_) => sl<PaymentChildrenCubit>(),
      child: BlocBuilder<PaymentChildrenCubit, PaymentChildrenState>(
        builder: (context, childrenState) {
          if (!_childrenLoadRequested &&
              _slotDraft != null &&
              childrenState is PaymentChildrenInitial) {
            _childrenLoadRequested = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<PaymentChildrenCubit>().load();
            });
          }

          final children = childrenState is PaymentChildrenLoaded
              ? childrenState.children
              : const <ParentChildModel>[];
          final names = children.map((c) => c.childName).toList();
          final selectedChild = _childByName(children, _childName);
          final bool childrenReady = childrenState is PaymentChildrenLoaded;
          final bool isButtonEnabled = _slotDraft != null &&
              _childName != null &&
              _selectedOption != null &&
              childrenReady &&
              selectedChild != null;

          return Scaffold(
            bottomNavigationBar: _BottomBookBar(
              enabled: isButtonEnabled,
              isDark: isDark,
              text: context.l10n.bookVisit,
              onTap: () {
                if (!isButtonEnabled) return;
                final base = _slotDraft!;
                final child = selectedChild;
                final years = _yearsOld(child.birthDate);
                final pay = _selectedOption == 0 ? 'on-visit' : 'visa';
                final next = base.copyWith(
                  childId: child.id,
                  childName: child.childName,
                  childYears: years,
                  paymentMethod: pay,
                  notes: _noteController.text.trim().isEmpty
                      ? null
                      : _noteController.text.trim(),
                );
                if (_selectedOption == 0) {
                  Navigator.pushNamed(
                    context,
                    PaymentSuccessScreen.routeName,
                    arguments: next,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    OnlinePaymentScreen.routeName,
                    arguments: next,
                  );
                }
              },
              padding: _kBottomBarPadding,
            ),
            backgroundColor: isDark
                ? AppColors.bg_surface_default_dark
                : AppColors.bg_surface_default_light,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: _kScreenTopPadding.h,
                  right: _kScreenHorizontalPadding.w,
                  left: _kScreenHorizontalPadding.w,
                ),
                child: ListView(
                  children: [
                    if (_slotDraft == null)
                      Text(
                        _kEmptyDraftMessage,
                        style: AppTextStyle.medium20TextDisplay(context),
                      )
                    else ...[
                      _HeaderRow(
                        isDark: isDark,
                        title: context.l10n.lastStepTitle,
                        subtitle: context.l10n.lastStepSubtitle,
                        onBack: () => Navigator.of(context).pop(),
                        buttonSize: _kHeaderButtonSize,
                      ),
                      SizedBox(height: _kSectionGapLg.h),
                      _PatientSelectorSection(
                        title: context.l10n.patient,
                        state: childrenState,
                        emptyMessage: _kNoChildrenMessage,
                        dropdownHint: context.l10n.selectYorChildName,
                        dropdownItems: names,
                        value: _childName,
                        dropdownHeight: _kPatientDropdownHeight,
                        loadingVerticalPadding: _kLoadingVerticalPadding,
                        onChanged: (val) => setState(() => _childName = val),
                      ),
                      SizedBox(height: _kSectionGapMd.h),
                      _VisitTypeSection(
                        title: context.l10n.visitType,
                        firstText: context.l10n.visitTypeExam,
                        secondText: context.l10n.visitTypeFollowUp,
                      ),
                      SizedBox(height: _kSectionGapMd.h),
                      _DoctorNoteSection(
                        title: context.l10n.doctorNote,
                        hintText: context.l10n.writeNoteHint,
                        controller: _noteController,
                        focusNode: _noteFocusNode,
                        height: _kNoteFieldHeight,
                        contentPadding: _kNoteFieldPadding,
                        isDark: isDark,
                      ),
                      SizedBox(height: _kSectionGapLg.h),
                      _PaymentMethodSection(
                        title: context.l10n.selectPaymentMethod,
                        payOnVisitText: context.l10n.payOnVisit,
                        payWithCardText: context.l10n.payWithCard,
                        selectedValue: _selectedOption,
                        onChanged: (val) => setState(() => _selectedOption = val),
                        gap: _kSectionGapSm,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomBookBar extends StatelessWidget {
  final bool enabled;
  final bool isDark;
  final String text;
  final VoidCallback onTap;
  final double padding;

  const _BottomBookBar({
    required this.enabled,
    required this.isDark,
    required this.text,
    required this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding.r),
      child: CustomButton(
        color: enabled
            ? (isDark
                ? AppColors.button_primary_default_dark
                : AppColors.button_primary_default_light)
            : (isDark
                ? AppColors.bg_button_primary_disabled_dark
                : AppColors.bg_button_primary_disabled_light),
        text: text,
        textColor: enabled
            ? (isDark ? AppColors.text_button_dark : AppColors.text_button_light)
            : (isDark
                ? AppColors.text_button_disabled_dark
                : AppColors.text_button_disabled_light),
        onTap: enabled ? onTap : () {},
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final double buttonSize;

  const _HeaderRow({
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomScreenHeader(title: title, subtitle: subtitle),
        ),
        CustomAppBarButton(
          width: buttonSize.w,
          height: buttonSize.h,
          color: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: AppRadius.radius_full,
          onTap: onBack,
        ),
      ],
    );
  }
}

class _PatientSelectorSection extends StatelessWidget {
  final String title;
  final PaymentChildrenState state;
  final String emptyMessage;
  final String dropdownHint;
  final List<String> dropdownItems;
  final String? value;
  final ValueChanged<String?> onChanged;
  final double dropdownHeight;
  final double loadingVerticalPadding;

  const _PatientSelectorSection({
    required this.title,
    required this.state,
    required this.emptyMessage,
    required this.dropdownHint,
    required this.dropdownItems,
    required this.value,
    required this.onChanged,
    required this.dropdownHeight,
    required this.loadingVerticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.bold12TextHeading(context)),
        SizedBox(height: AppSizes.h8),
        if (state is PaymentChildrenLoading || state is PaymentChildrenInitial)
          Padding(
            padding: EdgeInsets.symmetric(vertical: loadingVerticalPadding.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (state is PaymentChildrenError)
          Text(
            (state as PaymentChildrenError).message,
            style: AppTextStyle.medium12TextBody(context),
          )
        else if (dropdownItems.isEmpty)
          Text(
            emptyMessage,
            style: AppTextStyle.medium12TextBody(context),
          )
        else
          SizedBox(
            height: dropdownHeight.h,
            child: AnimatedDropdown(
              hintText: dropdownHint,
              items: dropdownItems,
              value: value,
              onChanged: onChanged,
            ),
          ),
      ],
    );
  }
}

class _VisitTypeSection extends StatelessWidget {
  final String title;
  final String firstText;
  final String secondText;

  const _VisitTypeSection({
    required this.title,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.bold12TextHeading(context)),
        SizedBox(height: AppSizes.h8),
        CustomToggleSelector(
          firstText: firstText,
          secondText: secondText,
          onChanged: (i) {},
        ),
      ],
    );
  }
}

class _DoctorNoteSection extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double height;
  final double contentPadding;
  final bool isDark;

  const _DoctorNoteSection({
    required this.title,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.height,
    required this.contentPadding,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.bold12TextHeading(context)),
        SizedBox(height: AppSizes.h8),
        SizedBox(
          height: height.h,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: AppTextStyle.bold12TextBody(context),
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyle.bold12TextBody(context),
              contentPadding: EdgeInsets.symmetric(
                horizontal: contentPadding.w,
                vertical: contentPadding.h,
              ),
              filled: true,
              fillColor: isDark
                  ? AppColors.bg_card_default_dark
                  : AppColors.bg_card_default_light,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light,
                  width: AppRadius.stroke_regular,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light,
                  width: AppRadius.stroke_regular,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  final String title;
  final String payOnVisitText;
  final String payWithCardText;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;
  final double gap;

  const _PaymentMethodSection({
    required this.title,
    required this.payOnVisitText,
    required this.payWithCardText,
    required this.selectedValue,
    required this.onChanged,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.bold16TextDisplay(context)),
        SizedBox(height: AppSizes.h12),
        Column(
          children: [
            SelectableOption(
              text: payOnVisitText,
              value: 0,
              imagePath: 'assets/Images/money.png',
              selectedValue: selectedValue,
              onChanged: onChanged,
            ),
            SizedBox(height: gap.h),
            SelectableOption(
              text: payWithCardText,
              imagePath: 'assets/Images/credit card.png',
              value: 1,
              selectedValue: selectedValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}
