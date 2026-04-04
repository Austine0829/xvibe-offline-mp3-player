import 'dart:math';

import 'package:flutter/material.dart';

class RandomColorPicker {
  static final _rng = Random();
  static final List<Color> _colorList = [
    Colors.lightBlueAccent,
    Colors.red,
    Colors.redAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.indigoAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.deepOrangeAccent,
  ];

  static Color generate() {
    return _colorList[_rng.nextInt(_colorList.length)];
  }
}