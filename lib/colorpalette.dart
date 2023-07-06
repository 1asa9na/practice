import 'package:flutter/material.dart';

class ColorPalette {
  Brightness brightness = Brightness.dark;
  final Color light;
  final Color dark;
  final Color accent;

  ColorPalette(this.light, this.dark, this.accent);
}
