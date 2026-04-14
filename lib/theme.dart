import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    brightness: Brightness.light,
  ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    brightness: Brightness.dark,
  ),
);

final themeMode = ValueNotifier(ThemeMode.light);
