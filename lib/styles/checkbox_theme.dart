
import 'package:flutter/material.dart';

final CheckboxThemeData checkboxThemeDataLight = CheckboxThemeData(
  checkColor: MaterialStateProperty.all<Color>(Colors.black),
  fillColor: MaterialStateProperty.all<Color>(Colors.grey),
  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
);
final CheckboxThemeData checkboxThemeDataDark = CheckboxThemeData(
  checkColor: MaterialStateProperty.all<Color>(Colors.black),
  fillColor: MaterialStateProperty.all<Color>(Colors.white),
  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
);