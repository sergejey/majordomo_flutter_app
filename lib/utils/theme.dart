import 'package:flutter/material.dart';

ThemeData lightAppTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500),
    bodySmall: TextStyle(fontSize: 12,
        fontWeight: FontWeight.w400,
        )
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xffe3eeff),
    iconTheme: IconThemeData(color: Color(0xff2b5eae)),
  ),
  //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, primary: const Color(0xff2b5eae), secondary: const Color(0xff2b5eae), onPrimary: const Color(0xff2b5eae), onSecondary: const Color(0xff2b5eae)),
  colorScheme: ColorScheme(primary: Color(0xff2b5eae),
    onPrimary: Colors.white,
    secondary: Color(0xFFBFCFE7),
    onSecondary: Color(0xFF322942),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xffe3eeff),
    onSurface: Color(0xff2b5eae),
    brightness: Brightness.light,)
);
