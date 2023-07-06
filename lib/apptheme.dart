import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colorpalette.dart';

class AppTheme {
  ColorPalette colorScheme;
  late Color mainThemeAccentColor;
  late Color mainThemeAmbientColor;
  late Color mainThemeElementColor;
  late TextStyle headerTextStyle;
  late TextStyle mainTextStyle;
  bool isLightThemeOn;

  AppTheme(this.colorScheme, {this.isLightThemeOn = false}) {
    colorScheme.brightness =
        isLightThemeOn ? Brightness.light : Brightness.dark;
    mainThemeAccentColor = colorScheme.brightness == Brightness.dark
        ? colorScheme.accent
        : colorScheme.light;
    mainThemeAmbientColor = colorScheme.brightness == Brightness.dark
        ? colorScheme.dark
        : Colors.white;
    mainThemeElementColor = colorScheme.brightness == Brightness.dark
        ? Colors.white
        : colorScheme.dark;
    headerTextStyle = GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        color: mainThemeElementColor,
        fontSize: 32);
    mainTextStyle = GoogleFonts.roboto(
      color: colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    );
  }
}
