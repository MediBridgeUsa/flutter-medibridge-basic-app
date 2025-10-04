import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primarySeedColor = Colors.deepPurple;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: _textTheme,
      appBarTheme: _appBarTheme(isDark: false),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardThemeData, 
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: _textTheme,
      appBarTheme: _appBarTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardThemeData, 
    );
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.openSans(fontSize: 14),
    headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
  );

  static AppBarTheme _appBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: isDark ? Colors.grey[900] : primarySeedColor,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      elevation: 4,
      shadowColor: Colors.black.withAlpha(128), // Corrected
    );
  }

  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      elevation: 2,
    ),
  );
  
  static final CardThemeData _cardThemeData = CardThemeData(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shadowColor: Colors.black.withAlpha(128), // Corrected
  );
}
