import 'package:flutter/material.dart';

/// AppTheme: Central Design System
///
/// Concepts Used:
/// 1. Material 3 Design: Utilizes Flutter's latest Material Design specifications (useMaterial3: true).
/// 2. Monochrome / High-Contrast Palette: Clean black, white, and subtle zinc borders.
/// 3. Semantic Color Coding: Green for open seats, Red for sold-out events.
class AppTheme {
  // Base Palette Colors
  static const Color background = Color(0xFFFAFAFA); // Soft off-white page background
  static const Color surface = Color(0xFFFFFFFF); // Pure white card & container surfaces
  static const Color surfaceVariant = Color(0xFFF4F4F5); // Light zinc for chips and tags
  static const Color primary = Color(0xFF09090B); // Pure dark black for buttons and active chips
  static const Color textPrimary = Color(0xFF09090B); // High-contrast main text
  static const Color textSecondary = Color(0xFF71717A); // Medium gray for subtitles & secondary labels
  static const Color textMuted = Color(0xFFA1A1AA); // Light gray for hints & placeholder text
  static const Color border = Color(0xFFE4E4E7); // Subtle 1px divider and outline border
  static const Color accent = Color(0xFF2563EB); // Vibrant blue accent
  static const Color badgeGreen = Color(0xFF15803D); // Indicates available seats
  static const Color badgeRed = Color(0xFFB91C1C); // Indicates low / sold-out seats

  /// Generates the global ThemeData configured for the application
  static ThemeData get lightTheme {
    return ThemeData(
      // Enable modern Material 3 styling
      useMaterial3: true,

      // Set global scaffold background color
      scaffoldBackgroundColor: background,

      // Global color scheme mappings
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: surface,
        secondary: accent,
        onSecondary: surface,
        surface: surface,
        onSurface: textPrimary,
        outline: border,
      ),

      // Global AppBar styling
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      // Global Card styling: flat border without heavy drop shadows
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),

      // Global ChoiceChip styling for category filters
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary,
        secondarySelectedColor: primary,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: surface,
        ),
        side: const BorderSide(color: border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // Global ElevatedButton styling: sleek dark pill buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Global OutlinedButton styling
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),

      // Global TextFormField input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: badgeRed, width: 1),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
    );
  }
}
