import 'package:flutter/material.dart';

enum AppTheme {
  darkTheme,
  lightTheme,
}

final appThemeData = {
  AppTheme.darkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0x0001d97c),
  ),
  AppTheme.lightTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
  )
};
