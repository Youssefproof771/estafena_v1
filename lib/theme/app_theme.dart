import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light tokens
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF1E2129);
  static const primary = Color(0xFF242833);
  static const primaryForeground = Color(0xFFF7F8FA);
  static const secondary = Color(0xFFEFF1F5);
  static const secondaryForeground = Color(0xFF333845);
  static const muted = Color(0xFFF1F3F7);
  static const mutedForeground = Color(0xFF767B88);
  static const border = Color(0xFFE5E8EE);
  static const accent = Color(0xFF38D5A3);
  static const positive = Color(0xFF10A37F);
  static const negative = Color(0xFFE5484D);

  // Dark tokens
  static const backgroundDark = Color(0xFF16181F);
  static const surfaceDark = Color(0xFF1E222D);
  static const foregroundDark = Color(0xFFF3F4F6);
  static const primaryDark = Color(0xFFEFF1F5);
  static const primaryForegroundDark = Color(0xFF1B1F2A);
  static const secondaryDark = Color(0xFF282E3C);
  static const secondaryForegroundDark = Color(0xFFEFF1F5);
  static const mutedDark = Color(0xFF282E3C);
  static const mutedForegroundDark = Color(0xFF9EA4B3);
  static const borderDark = Color(0x1FFFFFFF); // 12% white
  static const inputDark = Color(0x26FFFFFF); // 15% white

  // Gradients
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF282C38), Color(0xFF1C4556)],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF45DEAE), Color(0xFF3EB9D4)],
  );
}

class AppTheme {
  static const double radius = 16.0;

  static ThemeData get lightTheme {
    final baseText = GoogleFonts.dmSansTextTheme();
    final displayText = GoogleFonts.spaceGroteskTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        surface: AppColors.surface,
        onSurface: AppColors.foreground,
        error: AppColors.negative,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(baseText, displayText, AppColors.foreground),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(
        fillColor: AppColors.surface,
        borderColor: AppColors.border,
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseText = GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme);
    final displayText = GoogleFonts.spaceGroteskTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: AppColors.primaryForegroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.foregroundDark,
        error: AppColors.negative,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(
        baseText,
        displayText,
        AppColors.foregroundDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(
        fillColor: AppColors.surfaceDark,
        borderColor: AppColors.inputDark,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme base,
    TextTheme display,
    Color textColor,
  ) {
    return base.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        color: textColor,
        letterSpacing: -0.02 * 32,
      ),
      headlineSmall: display.headlineSmall?.copyWith(
        color: textColor,
        letterSpacing: -0.02 * 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: display.titleLarge?.copyWith(
        color: textColor,
        letterSpacing: -0.02 * 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static InputDecorationTheme _buildInputTheme({
    required Color fillColor,
    required Color borderColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius - 2),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius - 2),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius - 2),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    );
  }
}
