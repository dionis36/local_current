// lib/theme/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1F1F1F),
    primary: Color(0xFF1F1F1F),
    onPrimary: Color(0xFFFFFFFF),
  ),
).copyWith(
  // Apply a Google Font to the entire text theme
  textTheme: GoogleFonts.montserratTextTheme(),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    primary: Color(0xFFE0E0E0),
    onPrimary: Color(0xFF121212),
  ),
).copyWith(
  // Apply a Google Font to the entire text theme
  textTheme: GoogleFonts.montserratTextTheme(),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);