import 'package:flutter/material.dart';

TextTheme defaultTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ));

ThemeData lightAppTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: defaultTextTheme,
    appBarTheme: const AppBarTheme(
      color: Color(0xffe3eeff),
      iconTheme: IconThemeData(color: Color(0xff2b5eae)),
    ),
    colorScheme: ColorScheme(
      primary: Color(0xffffffff),
      onPrimary: Color(0xff2B5EAE),
      secondary: Color(0xff73A3ED),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: Color(0xffe3eeff),
      onSurface: Color(0xff2b5eae),
      brightness: Brightness.light,
      tertiary: Color(0xff2B5EAE),
      onTertiary: Color(0xffFFFFFF),
    ));

ThemeData darkAppTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: defaultTextTheme,
    appBarTheme: const AppBarTheme(
      color: Color(0xff2A2E31),
      iconTheme: IconThemeData(color: Color(0xffD7DFEC)),
    ),
    colorScheme: ColorScheme(
      primary: Color(0xff41444C),
      onPrimary: Color(0xffD7DFEC),
      secondary: Color(0xff41444C),
      onSecondary: Color(0xffD7DFEC),
      error: Colors.redAccent,
      onError: Colors.black,
      surface: Color(0xff2A2E31),
      onSurface: Color(0xffD7DFEC),
      tertiary: Color(0xff4F80D0),
      onTertiary: Color(0xffD7DFEC),
      brightness: Brightness.light,
    ));
