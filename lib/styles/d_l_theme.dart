import 'package:avalon_tool/styles/card_theme.dart';
import 'package:avalon_tool/styles/checkbox_theme.dart';
import 'package:avalon_tool/styles/inputfield_theme.dart';
import 'package:avalon_tool/styles/outlinedbutton_theme.dart';
import 'package:avalon_tool/styles/radio_theme.dart';
import 'package:avalon_tool/styles/switch_theme.dart';
import 'package:avalon_tool/styles/text_theme.dart';
import 'package:flutter/material.dart';


  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: textThemeLight,
    primaryColor: Colors.black,
    cardColor: Colors.grey,
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
    //cardColor: Colors.black45,
    outlinedButtonTheme: outlinedButtonThemeDataDark,
    checkboxTheme: checkboxThemeDataDark,
    inputDecorationTheme: inputDecorationThemeDark,
    radioTheme: radioThemeDataDark,
    cardTheme: cardThemeDark,
    switchTheme: switchThemeDark,
  );