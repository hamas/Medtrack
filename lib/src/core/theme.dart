import 'package:flutter/material.dart';

class MedTrackTheme {
  MedTrackTheme._();

  static final Color _brandBlue = Colors.blueAccent.shade700;

  static ThemeData lightTheme(ColorScheme? lightDynamic) {
    final ColorScheme scheme =
        lightDynamic ??
        ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.light,
        );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  static ThemeData darkTheme(ColorScheme? darkDynamic) {
    final ColorScheme scheme =
        darkDynamic ??
        ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.dark,
        );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
