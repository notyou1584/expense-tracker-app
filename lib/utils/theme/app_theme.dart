import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  @override
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.green[300]),
  );

  static final lightTheme = ThemeData(
    textTheme: GoogleFonts.montserratTextTheme(),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xFF80A8B0),
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
  );
}
