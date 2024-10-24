import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color? buttonTextColor = Colors.white;
Color? buttonBackgroundColor = Colors.indigoAccent[400];
Color? buttonShadowColor = Colors.indigoAccent;

Color? textColor = Colors.indigo;

Color? inputBackgroundColor = Colors.indigo[700];
Color? inputBorderSideColor = Colors.indigo[500];
Color? hintTextColor = Colors.grey[500];

Color? inputFillColor = Colors.grey[50];

final ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.indigo[50],
  //TextTheme
  textTheme: TextTheme(
    displayMedium: GoogleFonts.raleway(
      fontSize: 18,
      color: textColor
    )
  ),

  //TextFieldTheme / InputDecorationTheme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: inputFillColor!,
    border: OutlineInputBorder(
        borderSide: BorderSide(color: inputBorderSideColor!),
        borderRadius: BorderRadius.circular(14)
    ),
    hintStyle: TextStyle(
      color: hintTextColor
    )
  ),

  //ElevatedButtonTheme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStatePropertyAll(buttonShadowColor!),
      textStyle: WidgetStatePropertyAll(
          TextStyle(
              fontSize: 18
          )
      ),
      backgroundColor: WidgetStatePropertyAll(buttonBackgroundColor),
      foregroundColor: WidgetStatePropertyAll(buttonTextColor!),
      padding: WidgetStatePropertyAll(EdgeInsets.all(15))
    )
  ),
);