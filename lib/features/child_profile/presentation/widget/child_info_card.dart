import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/child_profile/domain/growth_monthly.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_cubit.dart';
import 'package:dana/features/child_profile/presentation/cubit/growth_state.dart';
import 'package:dana/features/child_profile/presentation/widget/child_info_card_helpers.dart';
import 'package:dana/features/child_profile/presentation/widget/child_info_header_row.dart';
import 'package:dana/features/child_profile/presentation/widget/child_picker_dropdown.dart';
import 'package:dana/features/child_profile/presentation/widget/child_stats_row.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChildInfoCard extends StatefulWidget {
  const ChildInfoCard({super.key, this.headerSnapshot, this.onSelectChild});

  /// Shown while growth is loading; usually route [ChildProfileArgs].
  final ChildProfileArgs? headerSnapshot;

  /// When the parent has multiple children, switches the active child (reload cubits from screen).
  final ValueChanged<String>? onSelectChild;

  @override
  State<ChildInfoCard> createState() => _ChildInfoCardState();
}

class _ChildInfoCardState extends State<ChildInfoCard> {
  bool _pickerExpanded = false;
  String? _lastSyncedChildId;

  Future<void> _pickAndUploadChildPhoto(
    BuildContext context, {
    required String childId,
    required String childName,
    required String gender,
    required DateTime? birthDate,
  }) async {
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addChildMissingFields),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (picked == null || !context.mounted) return;

    final parentCubit = context.read<ParentProfileCubit>();
    final err = await parentCubit.updateChild(
      childId: childId,
      childName: childName,
      gender: gender,
      birthDate: birthDate,
      profileImage: File(picked.path),
    );
    if (!context.mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await context.read<GrowthCubit>().load(childId: childId);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocBuilder<GrowthCubit, GrowthState>(
      builder: (context, growth) {
        final loaded = growth is GrowthLoaded ? growth : null;
        final snap = widget.headerSnapshot;

        final name = loaded?.childName ?? snap?.childName ?? '';
        final displayName = name;
        final birth = loaded?.birthDate ?? snap?.birthDate;
        final genderRaw =
            (loaded != null ? loaded.gender : (snap?.gender ?? ''))
                .toLowerCase();
        final isGirl = genderRaw == 'female';
        final gender = isGirl ? 'female' : 'male';
        // Important: once we have a loaded child, do NOT fall back to the route snapshot
        // image, otherwise switching children can temporarily (or permanently) show the
        // previous child's photo when the backend returns children as IDs without images.
        final profileUrl =
            loaded != null ? loaded.profileImageUrl : snap?.profileImageUrl;

        final age = ageFromBirth(birth);
        final ageText = context.formatAge(age.$1, age.$2);

        final records = loaded?.records ?? const [];
        final monthlyPair = growthLatestTwoMonths(records);
        final latestMonth = monthlyPair.$1;
        final prevMonth = monthlyPair.$2;

        final heightVal = statValue(latestMonth?.height ?? 0, context.l10n.cm);
        final weightVal = statValue(latestMonth?.weight ?? 0, context.l10n.kg);
        final headVal = statValue(
          latestMonth?.headCircumference ?? 0,
          context.l10n.cm,
        );

        final dh = deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.height,
          context.l10n.cm,
        );
        final dw = deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.weight,
          context.l10n.kg,
        );
        final dhc = deltaMonthly(
          latestMonth,
          prevMonth,
          (e) => e.headCircumference,
          context.l10n.cm,
        );

        if (loaded != null) {
          final cid = loaded.childId;
          if (_lastSyncedChildId != cid) {
            final hadPrevious = _lastSyncedChildId != null;
            _lastSyncedChildId = cid;
            if (hadPrevious && _pickerExpanded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _pickerExpanded = false);
              });
            }
          }
        }

        final showChildPicker =
            loaded != null &&
            loaded.children.length > 1 &&
            widget.onSelectChild != null;

        final otherChildren = loaded == null
            ? const <ParentChildModel>[]
            : loaded.children
                  .where((c) => c.id != loaded.childId)
                  .toList(growable: false);

        return CustomFrame(
          child: Column(
            children: [
              // Header row
              ChildInfoHeaderRow(
                displayName: displayName,
                ageText: ageText,
                isGirl: isGirl,
                isDark: isDark,
                showChildPicker: showChildPicker,
                pickerExpanded: _pickerExpanded,
                profileUrl: profileUrl,
                onPickerToggle: showChildPicker
                    ? () => setState(() => _pickerExpanded = !_pickerExpanded)
                    : null,
                onCameraTap: loaded != null
                    ? () => _pickAndUploadChildPhoto(
                        context,
                        childId: loaded.childId,
                        childName: loaded.childName,
                        gender: gender,
                        birthDate: loaded.birthDate,
                      )
                    : null,
              ),

              // Child picker dropdown
              if (showChildPicker &&
                  _pickerExpanded &&
                  otherChildren.isNotEmpty)
                ChildPickerDropdown(
                  otherChildren: otherChildren,
                  isDark: isDark,
                  onSelectChild: (id) {
                    setState(() => _pickerExpanded = false);
                    widget.onSelectChild!(id);
                  },
                ),

              // Divider
              Divider(
                height: 28.h,
                thickness: 0.5.h,
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
              ),

              // Stats row
              ChildStatsRow(
                heightVal: heightVal,
                weightVal: weightVal,
                headVal: headVal,
                dh: dh,
                dw: dw,
                dhc: dhc,
                growth: growth,
              ),
            ],
          ),
        );
      },
    );
  }
}
