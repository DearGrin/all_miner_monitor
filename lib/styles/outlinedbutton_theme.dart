
import 'package:avalon_tool/styles/d_l_theme.dart';
import 'package:avalon_tool/styles/text_theme.dart';
import 'package:flutter/material.dart';

OutlinedButtonThemeData outlinedButtonThemeDataLight = OutlinedButtonThemeData(
  style: ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle?>(textThemeLight.bodyText1),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
    overlayColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8.0)),
    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.black)),
    shape: MaterialStateProperty.all<OutlinedBorder> (const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),)
    ),
  )
);

OutlinedButtonThemeData outlinedButtonThemeDataDark = OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle?>(textThemeDark.bodyText1),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
      overlayColor: MaterialStateProperty.all<Color>(Colors.black38),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8.0)),
      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
      shape: MaterialStateProperty.all<OutlinedBorder> (const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),)
      ),
    )
);
