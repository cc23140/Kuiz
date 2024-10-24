import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: Colors.purple,
  scaffoldBackgroundColor: Colors.purple[700],
  buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      buttonColor: Colors.purple[900]
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.purple[500]),
    )
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);