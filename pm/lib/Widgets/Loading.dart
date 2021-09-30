import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Palette.primaryDark),
    );
  }
}
