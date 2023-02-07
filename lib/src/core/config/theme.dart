import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';

// App theme
ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(size: 20),
      backgroundColor: CustomColor.bg,
      elevation: 0,
      titleSpacing: 23,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: Colors.white.withOpacity(0.25),
        foregroundColor: Colors.white,
        backgroundColor: CustomColor.secondaryColor),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF16151C),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Colors.white),
  );
}
