// ignore: file_names
/*import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimaryColor = Color.fromARGB(255, 0, 182, 238);
  static const Color lightAccentColor = Color(0xFF03DAC6);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color darkPrimaryColor = Color.fromARGB(255, 1, 29, 17);
  static const Color darkAccentColor = Color(0xFF8E8E93);
  static const Color darkBackgroundColor = Color(0xFF212121);
  static const Color buttontheme = Color.fromRGBO(30, 81, 85, 1);
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
}*/
import 'package:demo222/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { light, dark }

final appThemeData = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    canvasColor: onBackgroundColor,
    fontFamily: GoogleFonts.nunito().fontFamily,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: pageBackgroundColor,
    shadowColor: primaryColor.withOpacity(1),
    textTheme: GoogleFonts.nunitoTextTheme(),
    tabBarTheme: TabBarTheme(
      labelColor: backgroundColor,
      labelStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      unselectedLabelColor: Colors.black26,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryColor,
      ),
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(
          secondary: secondaryColor,
          onPrimary: onPrimaryColor,
          background: backgroundColor,
          onSecondary: onSecondaryColor,
          onTertiary: primaryTxtColor,
        )
        .copyWith(background: backgroundColor),
  ),
  AppTheme.dark: ThemeData(
    primaryTextTheme: GoogleFonts.nunitoTextTheme(),
    textTheme: GoogleFonts.nunitoTextTheme(),
    fontFamily: GoogleFonts.nunito().fontFamily,
    shadowColor: darkPrimaryColor.withOpacity(0.25),
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkPageBackgroundColor,
    canvasColor: darkCanvasColor,
    tabBarTheme: TabBarTheme(
      labelColor: darkCanvasColor,
      labelStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      unselectedLabelColor: Colors.black26,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryColor,
      ),
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(
          brightness: Brightness.dark,
          secondary: darkSecondaryColor,
          onPrimary: darkOnPrimaryColor,
          background: darkBackgroundColor,
          onSecondary: darkOnSecondaryColor,
          onTertiary: darkPrimaryTxtColor,
          onSurface: darkLevelLockedColor,
        )
        .copyWith(background: darkBackgroundColor),
  ),
};
