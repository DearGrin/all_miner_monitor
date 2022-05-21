import 'package:AllMinerMonitor/styles/card_theme.dart';
import 'package:AllMinerMonitor/styles/checkbox_theme.dart';
import 'package:AllMinerMonitor/styles/inputfield_theme.dart';
import 'package:AllMinerMonitor/styles/outlinedbutton_theme.dart';
import 'package:AllMinerMonitor/styles/radio_theme.dart';
import 'package:AllMinerMonitor/styles/switch_theme.dart';
import 'package:AllMinerMonitor/styles/text_theme.dart';
import 'package:flutter/material.dart';


  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: textThemeLight,
    primaryColor: Colors.black,
    progressIndicatorTheme:  ProgressIndicatorThemeData(
      color: Colors.lightBlue,
      linearTrackColor: Colors.grey[200]!,
    ),
    appBarTheme:  AppBarTheme(
        backgroundColor:  Colors.grey[200]!,
      foregroundColor: Colors.black
    ),
    /*
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.grey[200]!,
        onPrimary: Colors.black,
        secondary: Colors.blueGrey,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.red[300]!,
        background: Colors.white,
        onBackground: Colors.black,
        surface:  Colors.grey[200]!,
        onSurface: Colors.black
    ),


     */
   // cardColor: Colors.grey[200],
    outlinedButtonTheme: outlinedButtonThemeDataLight,
    checkboxTheme: checkboxThemeDataLight,
    inputDecorationTheme: inputDecorationThemeLight,
    radioTheme: radioThemeDataLight,
    cardTheme: cardThemeLight,
    switchTheme: switchThemeLight,
  );

  final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black54,
    textTheme: textThemeDark,
    primaryColor: Colors.white,
    progressIndicatorTheme:  ProgressIndicatorThemeData(
      color: Colors.lightBlue,
      linearTrackColor: Colors.grey.shade900,
    ),
    appBarTheme:  AppBarTheme(
      backgroundColor:  Colors.grey.shade900,
        foregroundColor: Colors.white
    ),
    /*
    colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.grey.shade900,
        onPrimary: Colors.white,
        secondary: Colors.blue,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.red[300]!,
        background: Colors.black54,
        onBackground: Colors.white,
        surface:  Colors.grey.shade900,
        onSurface: Colors.white,
        primaryContainer: Colors.blue
    ),

     */
   // cardColor: Colors.red,
    outlinedButtonTheme: outlinedButtonThemeDataDark,
    checkboxTheme: checkboxThemeDataDark,
    inputDecorationTheme: inputDecorationThemeDark,
    radioTheme: radioThemeDataDark,
    cardTheme: cardThemeDark,
    switchTheme: switchThemeDark,
  );