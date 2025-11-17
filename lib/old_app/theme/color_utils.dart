import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color randomColor() {
    var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
    return color;
  }
  
  static Color numUsp93606070() {
    return const Color(0xFF8ED51E);
  }

  static var materialColors = const [
    Colors.blue,
    Colors.pink,
    Colors.yellow,
    Colors.cyan,
    Colors.deepOrange,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.grey,
    Colors.black,
    Colors.indigo,
  ];
}