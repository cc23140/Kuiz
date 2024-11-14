import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color preferredColor = const Color(0xff0D6EFD);
Color? buttonTextColor = Colors.white;
Color? buttonBackgroundColor = Colors.indigoAccent[400];
Color? buttonShadowColor = Colors.indigoAccent;

Color? textColor = Colors.indigo;

Color? inputBackgroundColor = Colors.indigo[700];
Color? inputBorderSideColor = Colors.grey;
Color? hintTextColor = Colors.grey[500];

Color? inputFillColor = Colors.grey[50];

final ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  //TextTheme
  textTheme: TextTheme(
    displayMedium: GoogleFonts.raleway(
      fontSize: 18,
      color: textColor
    )
  ),

  dividerTheme: DividerThemeData(
    color: Colors.blue,
    thickness: 2,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
  ),

  //TextFieldTheme / InputDecorationTheme
  inputDecorationTheme: InputDecorationTheme(

    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: preferredColor, width: 1.5),
      borderRadius: BorderRadius.circular(14)
    ),

    border: OutlineInputBorder(
        borderSide: BorderSide(color: inputBorderSideColor!),
        borderRadius: BorderRadius.circular(14)
    ),

    hintStyle: TextStyle(
      color: hintTextColor
    ),

  ),

  textSelectionTheme: TextSelectionThemeData(

    cursorColor: preferredColor
  ),

  //ElevatedButtonTheme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
        )
      ),
      shadowColor: WidgetStatePropertyAll(preferredColor),
      textStyle: WidgetStatePropertyAll(
          TextStyle(
              fontSize: 18
          )
      ),
      backgroundColor: WidgetStatePropertyAll(preferredColor),
      foregroundColor: WidgetStatePropertyAll(buttonTextColor!),
      padding: WidgetStatePropertyAll(EdgeInsets.all(15))
    )
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStatePropertyAll(preferredColor),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 18
        )
      ),
    )
  )
);