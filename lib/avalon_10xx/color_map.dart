import 'package:flutter/material.dart';

class ColorMap{
  static const List<Map<int, Color>> colors = [
    {10:Colors.white},
    {20:Colors.lightBlueAccent},
    {30:Colors.lightBlue},
    {40:Colors.blue},
    {50:Colors.blueAccent},
    {60:Colors.lightGreenAccent},
    {70:Colors.lightGreen},
    {80:Colors.green},
    {90:Colors.yellowAccent},
    {95:Colors.yellow},
    {100:Colors.redAccent},
    {150:Colors.red},
  ];
  Color getColor(int? temp){
    Color _ = Colors.white;
    int _t = temp ?? -40;
    for(int i = 0; i < colors.length; i++)
      {
        if(_t<=colors[i].keys.first)
          {
            _ = colors[i].values.first;
            break;
          }
      }
    return _;
  }
}