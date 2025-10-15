import 'package:flutter/material.dart';

class AppTheme {
  // -----------------------------
  // Couleurs personnalisées
  // -----------------------------
  static const Color primary = Color(0xFF1D61E7);          // violet bleu pour les boutons, liens
  static const Color paragraph = Color(0xFF6C7278);       // texte courant
  static const Color headline = Color(0xFF1A1C1E);        // grands titres
  static const Color buttonText = Color(0xFF232447);      // texte sur boutons
  static const Color inputText = Color(0xFF1A1C1E);       // texte des champs
  static const Color inputLabel = Color(0xFF6C7278);      // label des inputs
  static const Color background = Color(0xFFFFFFFF);      // fond clair
  static const Color surface = Color(0xFFF5F5F5);         // cartes / surfaces
  static const Color error = Color(0xFFB00020);           // rouge erreur

  // -----------------------------
  // Theme clair
  // -----------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: primary,
      onSecondary: Colors.white,
      background: background,
      onBackground: paragraph,
      surface: surface,
      onSurface: paragraph,
      error: error,
      onError: Colors.white,
    ),

    // TextTheme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 16,
        color: paragraph,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 14,
        color: paragraph,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: headline,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: headline,
      ),
    ),

    // Boutons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // InputDecoration pour les champs
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: inputLabel, fontFamily: 'SourceSansPro', fontSize: 14),
      hintStyle: TextStyle(color: inputText, fontFamily: 'SourceSansPro', fontSize: 16),
      border: OutlineInputBorder(),
    ),


  );
}
