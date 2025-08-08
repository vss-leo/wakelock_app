import 'package:flutter/material.dart';

/// Defines the light and dark themes for the app.

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A3A3A)),
  useMaterial3: true,
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3A3A3A), brightness: Brightness.dark),
  useMaterial3: true,
  brightness: Brightness.dark,
);