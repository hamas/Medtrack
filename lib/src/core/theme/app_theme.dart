import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedTrackTheme {
  MedTrackTheme._();

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
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.googleSans(
          color: darkScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w300,
          letterSpacing: 3.0,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: Colors.white.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.googleSans(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(size: 20, color: Color(0xFFF8FAFC)),
        ),
      ),
      iconTheme: const IconThemeData(weight: 600, color: Color(0xFFF8FAFC)),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B), // Slate 800
        contentTextStyle: GoogleFonts.googleSans(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),
    );
  }
}
