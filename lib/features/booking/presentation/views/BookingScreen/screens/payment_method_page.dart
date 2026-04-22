import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/animated_dropdown.dart';
import 'package:dana/core/widgets/custom_toggle_selector.dart';
import 'package:dana/core/widgets/selectable_option.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/Online_Payment_Screen.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/Payment_Confirm_Screen.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  static const String routeName = 'PaymentMethodScreen';

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  BookingDraft? _slotDraft;
  List<ParentChildModel> _children = const [];
  String? _childName;
  int? _selectedOption;
  bool _loadingChildren = true;
  String? _childrenError;

  final FocusNode _noteFocusNode = FocusNode();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteFocusNode.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final a = ModalRoute.of(context)?.settings.arguments;
    if (_slotDraft == null && a is BookingDraft) {
      _slotDraft = a;
      _loadChildren();
    }
  }

  Future<void> _loadChildren() async {
    setState(() {
      _loadingChildren = true;
      _childrenError = null;
    });
    try {
      final me = await sl<ParentProfileRepository>().getMe();
      if (!mounted) return;
      setState(() {
        _children = me.children;
        _loadingChildren = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _childrenError = e.toString();
        _loadingChildren = false;
      });
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

  ParentChildModel? _childByName(String? name) {
    if (name == null) return null;
    for (final c in _children) {
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

    final names = _children.map((c) => c.childName).toList();
    final bool isButtonEnabled =
        _slotDraft != null &&
        _childName != null &&
        _selectedOption != null &&
        !_loadingChildren &&
        _childByName(_childName) != null;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomButton(
          color: isButtonEnabled
              ? (isDark
                    ? AppColors.button_primary_default_dark
                    : AppColors.button_primary_default_light)
              : (isDark
                    ? AppColors.bg_button_primary_disabled_dark
                    : AppColors.bg_button_primary_disabled_light),
          text: 'احجز زيارتك',
          textColor: isButtonEnabled
              ? (isDark
                    ? AppColors.text_button_dark
                    : AppColors.text_button_light)
              : (isDark
                    ? AppColors.text_button_disabled_dark
                    : AppColors.text_button_disabled_light),
          onTap: () {
            if (!isButtonEnabled) return;
            final base = _slotDraft!;
            final child = _childByName(_childName)!;
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
        ),
      ),
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(top: 32.h, right: 24.w, left: 24.w),
          child: ListView(
            children: [
              if (_slotDraft == null)
                Text(
                  'لم يتم تحديد موعد. ارجع واختر التاريخ والوقت.',
                  style: AppTextStyle.medium20TextDisplay(context),
                )
              else ...[
                Text(
                  'خطوة أخيرة… علشان نطمن على ابنك',
                  style: AppTextStyle.medium20TextDisplay(context),
                ),
                SizedBox(height: AppSizes.h8),
                Text(
                  'اختار المريض وطريقة الدفع… وخلاص نكمّل الحجز.',
                  style: AppTextStyle.regular16TextBody(context),
                ),
                SizedBox(height: 24.h),
                Text('المريض', style: AppTextStyle.bold12TextHeading(context)),
                SizedBox(height: AppSizes.h8),
                if (_loadingChildren)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (_childrenError != null)
                  Text(
                    _childrenError!,
                    style: AppTextStyle.medium12TextBody(context),
                  )
                else if (names.isEmpty)
                  Text(
                    'لا يوجد أطفال مسجّلين. أضف طفلاً من الملف الشخصي.',
                    style: AppTextStyle.medium12TextBody(context),
                  )
                else
                  SizedBox(
                    height: 48.h,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: AnimatedDropdown(
                        hintText: 'أختر اسم طفلك',
                        items: names,
                        value: _childName,
                        onChanged: (val) {
                          setState(() {
                            _childName = val;
                          });
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
                Text(
                  'نوع الزيارة',
                  style: AppTextStyle.bold12TextHeading(context),
                ),
                SizedBox(height: AppSizes.h8),
                CustomToggleSelector(
                  firstText: 'كشف',
                  secondText: 'إعاده',
                  onChanged: (i) {},
                ),
                SizedBox(height: 16.h),
                Text(
                  'ملاحظة للطبيب',
                  style: AppTextStyle.bold12TextHeading(context),
                ),
                SizedBox(height: AppSizes.h8),
                SizedBox(
                  height: 85.h,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _noteController,
                      focusNode: _noteFocusNode,
                      style: AppTextStyle.bold12TextBody(context),
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'اكتب أي تعليق بسيط… (اختياري)',
                        hintStyle: AppTextStyle.bold12TextBody(context),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
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
                ),
                SizedBox(height: 24.h),
                Text(
                  'اختر طريقة الدفع',
                  style: AppTextStyle.bold16TextDisplay(context),
                ),
                SizedBox(height: AppSizes.h12),
                SizedBox(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        SelectableOption(
                          text: 'الدفع عند الزيارة',
                          value: 0,
                          imagePath: "assets/Images/money.png",
                          selectedValue: _selectedOption,
                          onChanged: (val) {
                            setState(() => _selectedOption = val);
                          },
                        ),
                        SizedBox(height: 12.h),
                        SelectableOption(
                          text: 'الدفع عن طريق الفيزا',
                          imagePath: "assets/Images/credit card.png",
                          value: 1,
                          selectedValue: _selectedOption,
                          onChanged: (val) {
                            setState(() => _selectedOption = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
