import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedTrackTheme {
  MedTrackTheme._();

  static ThemeData lightTheme() {
    const ColorScheme lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF2563EB), // Vibrant Blue
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF1E3A8A),
      secondary: Color(0xFF0284C7), // Light Blue
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE0F2FE),
      onSecondaryContainer: Color(0xFF075985),
      tertiary: Color(0xFF0D9488), // Teal
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFCCFBF1),
      onTertiaryContainer: Color(0xFF115E59),
      error: Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
      surface: Color(0xFF091413), // Deep Midnight Teal
      onSurface: Color(0xFFF8FAFC), // Slate 50
      surfaceContainerHighest: Color(0xFF1E293B),
      onSurfaceVariant: Color(0xFFE2E8F0),
      outline: Color(0xFF475569),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightScheme,
      textTheme: GoogleFonts.googleSansTextTheme(),
      scaffoldBackgroundColor:
          Colors.transparent, // Required for global background
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: lightScheme.surface,
        titleTextStyle: GoogleFonts.googleSans(
          color: lightScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightScheme.surface,
        indicatorColor: lightScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.googleSans(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(size: 20),
        ),
      ),
      iconTheme: const IconThemeData(
        weight: 600,
      ),
    );
  }

  static ThemeData darkTheme() {
    const ColorScheme darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF3B82F6),
      onPrimary: Color(0xFFEFF6FF),
      primaryContainer: Color(0xFF1E3A8A),
      onPrimaryContainer: Color(0xFFDBEAFE),
      secondary: Color(0xFF38BDF8),
      onSecondary: Color(0xFFF0F9FF),
      secondaryContainer: Color(0xFF075985),
      onSecondaryContainer: Color(0xFFE0F2FE),
      tertiary: Color(0xFF2DD4BF),
      onTertiary: Color(0xFFF0FDFA),
      tertiaryContainer: Color(0xFF115E59),
      onTertiaryContainer: Color(0xFFCCFBF1),
      error: Color(0xFFEF4444),
      onError: Color(0xFFFEF2F2),
      errorContainer: Color(0xFF991B1B),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF091413), // Deep Midnight Teal
      onSurface: Color(0xFFF8FAFC), // Slate 50
      surfaceContainerHighest: Color(0xFF1E293B),
      onSurfaceVariant: Color(0xFFE2E8F0),
      outline: Color(0xFF475569),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkScheme,
      textTheme: GoogleFonts.googleSansTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor:
          Colors.transparent, // Required for global background
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: darkScheme.surface,
        titleTextStyle: GoogleFonts.googleSans(
          color: darkScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkScheme.surface,
        indicatorColor: darkScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.googleSans(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(size: 20),
        ),
      ),
      iconTheme: const IconThemeData(
        weight: 600,
      ),
    );
  }
}
