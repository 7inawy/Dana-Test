import 'package:flutter/material.dart';
import '../../model/theme_model.dart';

class AppThemeHelper {
  final ThemeModel themeModel = ThemeModel();

  late final colors = _Colors(themeModel);
  late final text = _Text(themeModel);
  late final radius = _Radius(themeModel);
  late final spacing = _Spacing(themeModel);
}

///COLORS ///

class _Colors {
  final ThemeModel t;
  _Colors(this.t);

  Color _c(String? v, String fallback) => _parseColor(v ?? fallback);

  Color get primary =>
      _c(t.colorsSystemLight?.buttons?.bgButtonPrimaryHover?.value, '#3B82F6');

  Color get secondary => _c(
    t.colorsSystemLight?.buttons?.bgButtonPrimaryDefault2?.value,
    '#64748B',
  );

  Color get secondaryDefault => _parseColor('#EFA987');
  Color get borderCardDefault => _parseColor('#E3E7E8');
  Color get ButtonPrimary => _parseColor('#00AEC0');

  Color get background =>
      _c(t.colorsSystemLight?.backgrounds?.bgSurfaceDefault?.value, '#F9FAFA');

  Color get textColor =>
      _c(t.colorsSystemLight?.textSystem?.textDisplay?.value, '#0F1C1D');

  Color get card =>
      _c(t.colorsSystemLight?.cards?.bgCardDefault?.value, '#FFFFFF');

  Color get icon =>
      _c(t.colorsSystemLight?.icon?.colorIconOnLight?.value, '#0F1C1D');
}

Color _parseColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return Color(int.parse('0x$hexColor'));
}

/// =========================================================
/// TEXT ///
class _Text {
  final ThemeModel t;
  _Text(this.t);

  TextStyle _ts(
    String? size,
    double fallback, {
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: t.typographyArabic?.typeface?.family?.text?.value ?? 'Cairo',
      fontSize: double.tryParse(size ?? fallback.toString()) ?? fallback,
      fontWeight: weight,
      color: color ?? Colors.black,
    );
  }

  /// Body Sizes
  TextStyle get sm => _ts(
    t.typographyArabic?.typeface?.size?.sM?.value,
    14,
    weight: FontWeight.w500,
    color: Color(0xFF445A5D),
  );
  TextStyle get md => _ts(
    t.typographyArabic?.typeface?.size?.mD?.value,
    16,
    weight: FontWeight.w400,
    color: Color(0xFF445A5D),
  );
  TextStyle get lg => _ts(
    t.typographyArabic?.typeface?.size?.lG?.value,
    18,
    weight: FontWeight.w600,
  );
  TextStyle get xl => _ts(t.typographyArabic?.typeface?.size?.xL?.value, 24);

  TextStyle get heading => _ts(
    t.typographyArabic?.typeface?.size?.d2XL?.value,
    22,
    weight: FontWeight.w600,
  );

  TextStyle get body => _ts(
    t.typographyArabic?.typeface?.size?.mD?.value,
    16,
    weight: FontWeight.w400,
  );

  TextStyle get x2l => _ts(
    t.typographyArabic?.typeface?.size?.d2XL?.value,
    24,
    weight: FontWeight.w600,
    color: Color(0xFF0F1C1D),
  );

  TextStyle get x4l => _ts(
    t.typographyArabic?.typeface?.size?.d4XL?.value,
    32,
    weight: FontWeight.w600,
  );
}

/// =========================================================
/// RADIUS ///

class _Radius {
  final ThemeModel t;
  _Radius(this.t);

  double _d(String? v, String fb) =>
      double.tryParse(v ?? fb) ?? double.parse(fb);

  double get xs =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusXs?.value, '4');
  double get sm =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusSm?.value, '8');
  double get md =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusMd?.value, '12');
  double get lg =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusLg?.value, '16');
  double get xl =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusXl?.value, '20');
  double get full =>
      _d(t.numericTokensMode1?.cornerRadiusSystem?.radiusFull?.value, '50');
}

///  SPACING ///
/// =========================================================
class _Spacing {
  final ThemeModel t;
  _Spacing(this.t);

  double _d(String? v, String fb) =>
      double.tryParse(v ?? fb) ?? double.parse(fb);

  double get sm => _d(t.numericTokensMode1?.spacing?.spaceSm?.value, '8');
  double get md => _d(t.numericTokensMode1?.spacing?.spaceMd?.value, '16');
  double get lg => _d(t.numericTokensMode1?.spacing?.spaceLg?.value, '24');
}
