import 'package:flutter/material.dart';

final switchThemeLight = SwitchThemeData(
  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
  thumbColor: MaterialStateProperty.all<Color>(Colors.blue),
  trackColor: MaterialStateProperty.all<Color>(Colors.blue),
);
final switchThemeDark = SwitchThemeData(
  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
  thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  trackColor: MaterialStateProperty.all<Color>(Colors.blue),
);



