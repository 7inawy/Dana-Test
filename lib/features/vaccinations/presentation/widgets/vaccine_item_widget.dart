import 'package:dana/core/utils/date_formatter.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/vaccinations/presentation/bottom_sheets/confirm_vaccine_bottom_sheet.dart';
import 'package:dana/features/vaccinations/data/models/vaccine_model.dart';
import 'package:dana/features/vaccinations/presentation/widgets/painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../cubit/vaccination_schedule_cubit.dart';

class VaccineItemWidget extends StatefulWidget {
  final VaccineItem item;

  const VaccineItemWidget({super.key, required this.item});

  @override
  State<VaccineItemWidget> createState() => _VaccineItemWidgetState();
}

class _VaccineItemWidgetState extends State<VaccineItemWidget> {
  final TextEditingController _takenDateController = TextEditingController();
  DateTime? _selectedTakenDate;

  @override
  void dispose() {
    _takenDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final ui = getUI(widget.item.status, isDark);
    final iconPath = getIconPath(widget.item.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الخط و الايقونات
              SizedBox(
                child: Column(
                  children: [
                    // الأيقونة
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: ui.color),
                        shape: BoxShape.circle,
                        color: ui.color.withAlpha(31),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: SvgPicture.asset(
                          iconPath,
                          colorFilter: ColorFilter.mode(
                            ui.color,
                            BlendMode.srcIn,
                          ),
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                    ),
                    // الخط
                    if (ui.lineStyle != LineStyle.none)
                      Expanded(
                        child: ui.lineStyle == LineStyle.dashed
                            ? CustomPaint(
                                size: const Size(1, double.infinity),
                                painter: DashedLinePainter(color: ui.color),
                              )
                            : Container(width: 1.w, color: ui.color),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // التطعيمات
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: AppTextStyle.semibold16TextHeading(context),
                          ),
                          SizedBox(width: 8.w),
                          if (widget.item.status == VaccineStatus.delayed) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.error_subtle_dark
                                    : AppColors.error_subtle_light,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radius_lg,
                                ),
                              ),
                              child: Text(
                                context.l10n.vaccineDelayed,
                                style: AppTextStyle.semibold12ErrorDefault(
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      //الوصف
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                        child: Text(
                          widget.item.description,
                          style: AppTextStyle.medium12TextHeading(context),
                        ),
                      ),
                      // التاريخ
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/Icons/vaccine/time_icon.svg',
                            colorFilter: ColorFilter.mode(
                              ui.color,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            formatDate(context, widget.item.date),
                            style: TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                              fontSize: 12.sp,
                              color: ui.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Buttons
                      if (ui.showButtons) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            // تم اخذ الجرعه
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final scheduleCubit =
                                      context.read<VaccinationScheduleCubit>();
                                  _selectedTakenDate = null;
                                  _takenDateController.clear();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: isDark
                                        ? AppColors.bg_surface_default_dark
                                        : AppColors.bg_surface_default_light,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.r),
                                      ),
                                    ),
                                    builder: (_) => StatefulBuilder(
                                      builder: (sheetContext, setModalState) =>
                                          ConfirmVaccineBottomSheet(
                                            firstText: context
                                                .l10n
                                                .vaccineSuccessTitle,
                                            firstTextStyle:
                                                AppTextStyle.semibold20Success(
                                                  context,
                                                ),
                                            secondText:
                                                context.l10n.vaccineSuccessDesc,
                                            photoSrc:
                                                'assets/Icons/vaccine/vaccine_done.svg',
                                            extraWidgets: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 24.h,
                                                    bottom: 8.h,
                                                  ),
                                                  child: Text(
                                                    context
                                                        .l10n
                                                        .vaccineDateLabel,
                                                    style:
                                                        AppTextStyle.medium12TextHeading(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                                CustomTextField(
                                                  hintText: context
                                                      .l10n
                                                      .vaccineDateHint,
                                                  readOnly: true,
                                                  icon: Icons
                                                      .calendar_month_rounded,
                                                  controller:
                                                      _takenDateController,
                                                  onTap: () async {
                                                    final picked =
                                                        await showDatePicker(
                                                          context: sheetContext,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate: DateTime(
                                                            1900,
                                                          ),
                                                          lastDate:
                                                              DateTime.now(),
                                                          locale: const Locale(
                                                            "ar",
                                                          ),
                                                        );
                                                    if (picked != null) {
                                                      setModalState(() {
                                                        _selectedTakenDate =
                                                            picked;
                                                        _takenDateController
                                                            .text = formatDate(
                                                          context,
                                                          picked,
                                                        );
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            buttonText:
                                                context.l10n.saveToRecord,
                                            onConfirm: () async {
                                              final childId =
                                                  widget.item.childId;
                                              final vaccinationId =
                                                  widget.item.vaccinationId;
                                              final takenDate =
                                                  _selectedTakenDate;
                                              if (childId == null ||
                                                  childId.isEmpty ||
                                                  vaccinationId == null ||
                                                  vaccinationId.isEmpty ||
                                                  takenDate == null) {
                                                return;
                                              }
                                              await scheduleCubit.markTaken(
                                                childId: childId,
                                                vaccinationId: vaccinationId,
                                                takenDate: takenDate,
                                              );
                                              if (!mounted) return;
                                              // Close the confirm sheet after a successful call.
                                              Navigator.of(sheetContext).pop();
                                            },
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.button_primary_default_dark
                                        : AppColors
                                              .button_primary_default_light,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.radius_lg,
                                    ),
                                    border: Border.all(
                                      width: AppRadius.stroke_thin,
                                      color: isDark
                                          ? AppColors
                                                .button_primary_default_dark
                                          : AppColors
                                                .button_primary_default_light,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        context.l10n.vaccineTaken,
                                        style:
                                            AppTextStyle.semibold12TextButton(
                                              context,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // لم يتم بعد
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: isDark
                                        ? AppColors.bg_surface_default_dark
                                        : AppColors.bg_surface_default_light,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.r),
                                      ),
                                    ),
                                    builder: (_) => ConfirmVaccineBottomSheet(
                                      firstText: context.l10n.vaccineAlertTitle,
                                      firstTextStyle:
                                          AppTextStyle.semibold20ErrorDefault(
                                            context,
                                          ),
                                      secondText: context.l10n.vaccineAlertDesc,
                                      photoSrc:
                                          'assets/Icons/vaccine/vaccine_not_done.svg',
                                      buttonText: context.l10n.cancel,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.radius_lg,
                                    ),
                                    border: Border.all(
                                      width: AppRadius.stroke_bold,
                                      color: isDark
                                          ? AppColors
                                                .border_button_outlined_dark
                                          : AppColors
                                                .border_button_outlined_light,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        context.l10n.vaccineNotTaken,
                                        style:
                                            AppTextStyle.semibold12TextButtonOutlined(
                                              context,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
