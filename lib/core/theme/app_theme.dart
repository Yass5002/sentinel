import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF4F00); // Sentinel Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red

  // Netflix-style Dark Theme Tokens
  static const Color pureBlack = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF333333);
  static const Color lightGreyText = Color(0xFFB3B3B3);
  static const Color whiteText = Color(0xFFFFFFFF);

  // Sharp corners as specified
  static const double borderRadius = 0.0;

  static const String brandFont = 'SentinelBrand';

  static ThemeData getTheme(Locale? locale) {
    final bool isArabic = locale?.languageCode == 'ar';
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pureBlack,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: whiteText,
        surface: darkSurface,
        onSurface: whiteText,
        error: Color(0xFFD32F2F),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pureBlack,
        foregroundColor: whiteText,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteText,
          disabledBackgroundColor: const Color.fromARGB(
            128,
            255,
            79,
            0,
          ), // Base color with 50% opacity
          disabledForegroundColor: const Color.fromARGB(
            179,
            255,
            255,
            255,
          ), // White with ~70% opacity
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        hintStyle: TextStyle(color: lightGreyText),
        labelStyle: TextStyle(color: lightGreyText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Sharp corners
          borderSide: BorderSide.none, // No outline borders
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFD32F2F), width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: TextStyle(color: Color(0xFFD32F2F)),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: Color(0x4DFF4F00),
        selectionHandleColor: primaryColor,
      ),
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: whiteText),
        bodyLarge: TextStyle(color: whiteText),
        titleLarge: TextStyle(color: whiteText, fontWeight: FontWeight.bold),
      ),
      fontFamily: isArabic ? 'Alyamama' : null,
    );
  }

  static ThemeData get darkTheme => getTheme(null);
  static ThemeData get lightTheme => darkTheme;
}
