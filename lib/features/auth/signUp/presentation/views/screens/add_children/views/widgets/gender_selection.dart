// import 'package:dana/core/utils/app_colors.dart';
// import 'package:dana/core/utils/app_raduis.dart';
// import 'package:dana/core/utils/app_sizes.dart';
// import 'package:dana/core/utils/app_text_style.dart';
// import 'package:dana/l10n/app_localizations.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../../../../../../../../providers/app_theme_provider.dart';

// class GenderSelection extends StatelessWidget {
//   const GenderSelection({
//     super.key,
//     required this.selectedIndex,
//     required this.onSelect,
//   });

//   final int selectedIndex;
//   final ValueChanged<int> onSelect;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.watch<AppThemeProvider>().appTheme == ThemeMode.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.bg_surface_default_dark
//             : AppColors.bg_surface_default_light,
//         border: Border.all(
//           color: isDark
//               ? AppColors.border_card_default_dark
//               : AppColors.border_card_default_light,
//           width: AppRadius.stroke_thin,
//         ),
//         borderRadius: BorderRadius.circular(AppRadius.radius_sm),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(AppRadius.radius_xs),
//         child: Row(
//           children: [
//             _GenderItem(
//               text: AppLocalizations.of(context)!.boy,
//               isSelected: selectedIndex == 0,
//               onTap: () => onSelect(0),
//             ),
//             SizedBox(width: 8.w),
//             _GenderItem(
//               text: AppLocalizations.of(context)!.girl,
//               isSelected: selectedIndex == 1,
//               onTap: () => onSelect(1),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GenderItem extends StatelessWidget {
//   const _GenderItem({
//     required this.text,
//     required this.isSelected,
//     required this.onTap,
//   });

//   final String text;
//   final bool isSelected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.watch<AppThemeProvider>().appTheme == ThemeMode.dark;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? isDark
//                       ? AppColors.primary_50_dark
//                       : AppColors.primary_50_light
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(AppRadius.space_xs),
//           ),
//           child: Text(
//             text,
//             style: AppTextStyle.medium16TextHeading(context).copyWith(
//               color: isSelected
//                   ? isDark
//                         ? AppColors.primary_default_dark
//                         : AppColors.primary_default_light
//                   : isDark
//                   ? AppColors.text_heading_dark
//                   : AppColors.text_heading_light,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
