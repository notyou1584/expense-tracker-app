// ignore: file_names
import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Color.fromARGB(255, 0, 182, 238);
  static const Color lightAccentColor = Color(0xFF03DAC6);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color darkPrimaryColor = Color.fromARGB(255, 1, 29, 17);
  static const Color darkAccentColor = Color(0xFF8E8E93);
  static const Color darkBackgroundColor = Color(0xFF212121);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      secondaryHeaderColor: lightAccentColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      secondaryHeaderColor: darkAccentColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
