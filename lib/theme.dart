import 'package:flutter/material.dart';

/// DrillDeck palette, taken from the app icon.
class AppColors {
  static const blue = Color(0xFF0B5ED7);
  static const navy = Color(0xFF0A2A66);
  static const yellow = Color(0xFFFFD43B);
  static const card = Color(0xFFFFFFFF);
  static const background = Color(0xFFF3F6FB);
  static const correct = Color(0xFF1E9E5A);
  static const wrong = Color(0xFFD93B30);
  static const muted = Color(0xFF8A97B0);
  static const border = Color(0xFFDDE4F0);
}

const headingFont = 'Poppins';
const bodyFont = 'NotoSans';

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    primary: AppColors.blue,
    secondary: AppColors.yellow,
    surface: AppColors.card,
    error: AppColors.wrong,
  );

  const heading = TextStyle(fontFamily: headingFont, color: AppColors.navy);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: bodyFont,
    textTheme: TextTheme(
      headlineLarge: heading.copyWith(fontSize: 30, fontWeight: FontWeight.w700),
      headlineMedium: heading.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: heading.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: heading.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
      bodyLarge: const TextStyle(fontSize: 18, height: 1.45, color: AppColors.navy),
      bodyMedium: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.navy),
      labelLarge: const TextStyle(fontFamily: headingFont, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontFamily: headingFont, fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: AppColors.blue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontFamily: headingFont, fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.navy,
    ),
  );
}

/// White rounded card with a soft shadow, used for every content card.
BoxDecoration cardDecoration({Color color = AppColors.card}) => BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Color(0x140A2A66), blurRadius: 16, offset: Offset(0, 6)),
      ],
    );
