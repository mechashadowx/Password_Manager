import 'package:flutter/material.dart';

class Spacers {
  static const Widget h32 = SizedBox(height: 32.0);
  static const Widget h16 = SizedBox(height: 16.0);
  static const Widget h8 = SizedBox(height: 8.0);

  static Widget customSpacer(double h) {
    return SizedBox(height: h);
  }
}
