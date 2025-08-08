import 'package:flutter/material.dart';

/// Primary radius used throughout the app.
const _radius = 20.0;

/// Builds a base theme for the given [brightness].
ThemeData _buildTheme(Brightness brightness) {
  final seed = const Color(0xFF4A90E2); // soft blue
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: brightness,
    textTheme: ThemeData(brightness: brightness).textTheme.apply(
          fontSizeFactor: 1.1,
          fontFamily: 'SF Pro',
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        minimumSize: const Size.fromHeight(52),
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed)
              ? scheme.primary.withOpacity(0.1)
              : null,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
  );
}

/// Light theme following the WakeLock design system.
final lightTheme = _buildTheme(Brightness.light);

/// Dark theme following the WakeLock design system.
final darkTheme = _buildTheme(Brightness.dark);
