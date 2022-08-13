import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';


ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
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
    scaffoldBackgroundColor: CustomColor.bg,
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Colors.white),
  );
}
