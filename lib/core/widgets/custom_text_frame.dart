import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CustomTextFrame extends StatelessWidget {
  final double? width;
  final double? height;
  final double bottomMargin;
  final double? vPadding;
  final double? hPadding;
  final String text;
  final TextStyle? textStyle;
  final String? sufText;
  final String? preIconSrc;
  final double? preIconWidth;
  final Color? preIconBackgroundColor;
  final double? preIconPadding;
  final double? preIconBorderRadius;
  final Color? preIconColor;
  final String? sufIconSrc;
  final double? sufIconWidth;
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  final VoidCallback? onTap;

  final bool isSelectable;
  final bool isSelected;

  const CustomTextFrame({
    super.key,
    this.width,
    this.height,
    required this.text,
    this.textStyle,
    this.sufText = '',
    this.preIconSrc,
    this.preIconWidth,
    this.preIconBackgroundColor,
    this.preIconPadding,
    this.preIconBorderRadius,
    this.preIconColor,
    this.sufIconSrc,
    this.sufIconWidth,
    this.bottomMargin = 0,
    this.vPadding,
    this.hPadding,
    this.onTap,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.isSelectable = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: bottomMargin),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isDark
                  ? AppColors.bg_card_default_dark
                  : AppColors.bg_card_default_light),
          borderRadius: BorderRadius.circular(AppRadius.radius_md),
          border: Border.all(
            width: borderWidth ?? AppRadius.stroke_more_thin,
            color:
                borderColor ??
                (isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: vPadding ?? 16.h,
            horizontal: hPadding ?? 16.w,
          ),
          child: Row(
            children: [
              if (preIconSrc != null) ...[
                preIconBackgroundColor != null ||
                        preIconPadding != null ||
                        preIconBorderRadius != null
                    ? Container(
                        padding: EdgeInsets.all(preIconPadding ?? 4.r),
                        decoration: BoxDecoration(
                          color: preIconBackgroundColor ?? Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            preIconBorderRadius ?? AppRadius.radius_sm,
                          ),
                        ),
                        child: SvgPicture.asset(
                          preIconSrc!,
                          colorFilter: ColorFilter.mode(
                            preIconColor ??
                                (isDark
                                    ? const Color.fromARGB(255, 63, 157, 168)
                                    : AppColors.primary_default_light),
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        preIconSrc!,
                        colorFilter: ColorFilter.mode(
                          preIconColor ??
                              (isDark
                                  ? AppColors.primary_default_dark
                                  : AppColors.primary_default_light),
                          BlendMode.srcIn,
                        ),
                      ),
                SizedBox(width: 12.w),
              ],

              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child:
                          child ??
                          Text(
                            text,
                            style:
                                textStyle ??
                                AppTextStyle.medium16TextHeading(context),
                          ),
                    ),
                    Text(
                      sufText!,
                      style: AppTextStyle.regular12TextBody(context),
                    ),
                  ],
                ),
              ),

              if (isSelectable)
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: isSelected ? 5.w : 1.w,
                      color: isSelected
                          ? (isDark
                                ? AppColors.primary_default_dark
                                : AppColors.primary_default_light)
                          : (isDark
                                ? AppColors.border_card_default_dark
                                : AppColors.border_card_default_light),
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.bg_surface_default_dark
                                  : AppColors.bg_surface_default_light,
                            ),
                          ),
                        )
                      : const SizedBox(),
                )
              else if (sufIconSrc != null)
                Row(
                  children: [
                    SizedBox(width: 8.w),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                        Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : 3.14,
                      ),
                      child: SvgPicture.asset(
                        sufIconSrc!,
                        width: sufIconWidth,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? AppColors.icon_onLight_dark
                              : AppColors.icon_onLight_light,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
