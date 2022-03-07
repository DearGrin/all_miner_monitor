import 'package:avalon_tool/styles/text_theme.dart';
import 'package:flutter/material.dart';

class Themes{
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: ThemeText.textTheme,
      primaryColor: Colors.black,
  );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    textTheme: ThemeText.textTheme,
      primaryColor: Colors.white,
  );
}