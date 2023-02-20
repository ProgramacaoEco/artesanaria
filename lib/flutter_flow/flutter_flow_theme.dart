// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return DarkModeTheme();
  }

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color red;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;
  late Color darkBG;

  late Color dark2BG;
  late Color greyBG;
  late Color textGrey;
  late Color textGreyWhite;
  late Color whiteGrey;

  late Color primaryBtnText;
  late Color lineColor;
  late Color white;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  Color primaryColor = const Color.fromARGB(255, 255, 127, 0);
  Color secondaryColor = Color.fromARGB(255, 135, 135, 135);
  Color tertiaryColor = const Color(0xFFEE8B60);
  Color alternate = const Color(0xFF067006);
  Color red = Colors.red;

  Color primaryBackground = const Color.fromARGB(255, 35, 35, 35);
  Color secondaryBackground = const Color.fromARGB(255, 235, 235, 235);
  Color primaryText = const Color.fromARGB(255, 235, 235, 235);
  Color secondaryText = const Color.fromARGB(255, 35, 35, 35);
  Color darkBG = Color.fromARGB(255, 35, 35, 35);
  Color dark2BG = Color.fromARGB(255, 60, 70, 78);
  Color greyBG = Color.fromARGB(255, 88, 101, 112);
  Color textGrey = Color.fromARGB(255, 135, 135, 135);
  Color textGreyWhite = Color.fromARGB(255, 189, 188, 188);
  Color whiteGrey = Color.fromARGB(255, 228, 226, 226);

  Color primaryBtnText = Color.fromARGB(255, 235, 235, 235);
  Color lineColor = Color.fromARGB(255, 235, 235, 235);

  Color white = Color.fromARGB(255, 235, 235, 235);
}

class DarkModeTheme extends FlutterFlowTheme {
  Color primaryColor = const Color.fromARGB(255, 255, 127, 0);
  Color secondaryColor = Color.fromARGB(255, 135, 135, 135);
  Color tertiaryColor = const Color(0xFFEE8B60);
  Color alternate = const Color(0xFF067006);

  Color primaryBackground = const Color.fromARGB(255, 35, 35, 35);
  Color secondaryBackground = const Color.fromARGB(255, 235, 235, 235);
  Color primaryText = const Color(0xFF353535);
  Color secondaryText = const Color(0xFF575656);
  Color darkBG = Color.fromARGB(255, 35, 35, 35);
  Color dark2BG = Color.fromARGB(255, 60, 70, 78);
  Color greyBG = Color.fromARGB(255, 88, 101, 112);
  Color textGrey = Color.fromARGB(255, 135, 135, 135);
  Color textGreyWhite = Color.fromARGB(255, 189, 188, 188);
  Color whiteGrey = Color.fromARGB(255, 228, 226, 226);

  Color primaryBtnText = Color.fromARGB(255, 235, 235, 235);
  Color lineColor = Color.fromARGB(255, 235, 235, 235);

  Color white = Color.fromARGB(255, 235, 235, 235);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get title1Family => 'Roboto';
  TextStyle get title1 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title2Family => 'Roboto';
  TextStyle get title2 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title3Family => 'Roboto';
  TextStyle get title3 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Roboto';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.primaryText,
        fontWeight: FontWeight.w800,
        fontSize: 40,
      );
  String get subtitle2Family => 'Roboto';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  String get bodyText1Family => 'Roboto';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  String get bodyText2Family => 'Roboto';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Nanum Gothic',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
