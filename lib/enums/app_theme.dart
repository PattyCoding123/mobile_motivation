import 'package:flutter/material.dart';

enum AppTheme {
  darkTheme,
}

final appThemeData = {
  AppTheme.values: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0x0001d97c),
  )
};
