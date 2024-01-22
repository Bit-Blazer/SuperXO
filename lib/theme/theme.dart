import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'Rammetto One',
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(),
);

ThemeData darkMode = ThemeData(
  fontFamily: 'Rammetto One',
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(),
);
