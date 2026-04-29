import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AnimatedDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const AnimatedDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown>
    with SingleTickerProviderStateMixin {
  static const Duration _kToggleDuration = Duration(milliseconds: 200);
  static const double _kBorderRadius = 8;
  static const double _kBorderWidth = 0.8;
  static const double _kOverlayYOffset = 5;
  static const int _kMaxVisibleItemsBeforeScroll = 2;
  static const double _kOverlayMaxHeight = 95;
  static const double _kItemHorizontalPadding = 16;
  static const double _kItemVerticalPadding = 10;
  static const double _kFieldHorizontalPadding = 16;
  static const double _kFieldVerticalPadding = 12;
  static const double _kArrowSize = 24;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _kToggleDuration,
    );
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  void _toggleDropdown() {
    if (isOpen) {
      _controller.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      isOpen = false;
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
      isOpen = true;
    }
  }

  OverlayEntry _createOverlay() {
    final themeProvider = context.read<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + _kOverlayYOffset),
          child: Material(
            color: Colors.transparent,
            child: SizeTransition(
              sizeFactor: _heightAnimation,
              axisAlignment: -1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.bg_card_default_dark
                      : AppColors.bg_card_default_light,
                  borderRadius: BorderRadius.circular(_kBorderRadius.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.border_card_default_dark
                        : AppColors.border_card_default_light,
                    width: _kBorderWidth.w,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // `items.length` is a count; compare to an int (not screen units).
                    maxHeight: widget.items.length > _kMaxVisibleItemsBeforeScroll
                        ? _kOverlayMaxHeight.h
                        : double.infinity,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: widget.items.map((item) {
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _toggleDropdown();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _kItemHorizontalPadding.w,
                            vertical: _kItemVerticalPadding.h,
                          ),
                          child: Text(
                            item,
                            style: AppTextStyle.bold12TextHeading(context),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeDropdown() {
    if (!isOpen) return;
    isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_controller.isAnimating || _controller.value != 0) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final bool hasValue = widget.value != null && widget.value!.isNotEmpty;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _kFieldHorizontalPadding.w,
            vertical: _kFieldVerticalPadding.h,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light,
            borderRadius: BorderRadius.circular(_kBorderRadius.r),
            border: Border.all(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              width: _kBorderWidth.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hasValue ? widget.value! : widget.hintText,
                  style: hasValue
                      ? AppTextStyle.bold12TextHeading(context)
                      : AppTextStyle.regular12TextBody(context),
                ),
              ),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
              duration: _kToggleDuration,
                child: SvgPicture.asset(
                  'assets/Icons/arrow_drop_icon.svg',
                width: _kArrowSize.w,
                height: _kArrowSize.h,
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
        ),
      ),
    );
  }
}
