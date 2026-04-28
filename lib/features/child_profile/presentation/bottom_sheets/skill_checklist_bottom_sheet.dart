import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/skill_api_models.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';

class SkillChecklistBottomSheet extends StatefulWidget {
  final String skillId;
  final String title;
  final String description;

  const SkillChecklistBottomSheet({
    super.key,
    required this.skillId,
    required this.title,
    required this.description,
  });

  @override
  State<SkillChecklistBottomSheet> createState() =>
      _SkillChecklistBottomSheetState();
}

class _SkillChecklistBottomSheetState extends State<SkillChecklistBottomSheet> {
  bool _hasLocalChanges = false;

  void _markChanged() {
    if (_hasLocalChanges) return;
    setState(() => _hasLocalChanges = true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SafeArea(
      top: false,
      child: BlocBuilder<SkillsCubit, SkillsState>(
        builder: (context, state) {
          final items = state is ChecklistLoaded
              ? state.items
              : <SkillChecklistItemApiModel>[];
          final loading = state is ChecklistLoading || state is SkillsLoading;

          final isButtonEnabled = _hasLocalChanges && !loading;
          final disabledColor = isDark
              ? AppColors.button_primary_default_dark.withValues(alpha: 0.35)
              : AppColors.button_primary_default_light.withValues(alpha: 0.35);
          final disabledBorder = isDark
              ? AppColors.border_button_primary_dark.withValues(alpha: 0.35)
              : AppColors.border_button_primary_light.withValues(alpha: 0.35);

          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: 24.w,
              start: 24.w,
              bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: HomeIndicator()),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.medium20TextDisplay(context),
                      ),
                    ),
                    _CloseButton(isDark: isDark),
                  ],
                ),
                if (widget.description.trim().isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                ],
                SizedBox(height: 16.h),

                Flexible(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : items.isEmpty
                      ? Center(
                          child: Text(
                            '—',
                            style: AppTextStyle.regular16TextBody(context),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
                          itemBuilder: (context, i) => _ChecklistRow(
                            item: items[i],
                            isDark: isDark,
                            skillId: widget.skillId,
                            onChanged: _markChanged,
                          ),
                        ),
                ),

                SizedBox(height: 16.h),
                CustomButton(
                  text: context.l10n.saveProgress,
                  onTap: isButtonEnabled
                      ? () => Navigator.of(context).maybePop()
                      : () {},
                  color: isButtonEnabled ? null : disabledColor,
                  borderColor: isButtonEnabled ? null : disabledBorder,
                  textStyle: AppTextStyle.semibold16TextButton(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final bool isDark;

  const _CloseButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? AppColors.border_card_default_dark : AppColors.border_card_default_light;
    final bgColor =
        isDark ? AppColors.bg_surface_subtle_dark : AppColors.bg_surface_subtle_light;
    final iconColor = isDark ? AppColors.icon_onDark_dark : AppColors.icon_onLight_light;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonLabel,
      child: InkWell(
        onTap: () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.radius_sm),
            border: Border.all(color: borderColor, width: AppRadius.stroke_thin),
          ),
          child: Icon(Icons.close, color: iconColor, size: 20.sp),
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final SkillChecklistItemApiModel item;
  final bool isDark;
  final String skillId;
  final VoidCallback? onChanged;

  const _ChecklistRow({
    required this.item,
    required this.isDark,
    required this.skillId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call();
        context.read<SkillsCubit>().toggle(
          skillId: skillId,
          itemId: item.id,
          checked: !item.checked,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: item.checked
              ? isDark
                    ? AppColors.primary_50_dark
                    : AppColors.primary_50_light
              : isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_md),
          border: Border.all(
            color: item.checked
                ? isDark
                      ? AppColors.primary_default_dark
                      : AppColors.primary_default_light
                : isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyle.medium16TextBody(context),
              ),
            ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Checkbox(
                value: item.checked,
                onChanged: (val) {
                  onChanged?.call();
                  context.read<SkillsCubit>().toggle(
                    skillId: skillId,
                    itemId: item.id,
                    checked: val ?? false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
