import 'package:flutter/material.dart';

enum AppTheme {
  darkTheme,
  lightTheme,
}

final appThemeData = {
  AppTheme.darkTheme: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0x0001d97c),
    colorScheme: const ColorScheme.dark(),
  ),
  AppTheme.lightTheme: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
  )
};
