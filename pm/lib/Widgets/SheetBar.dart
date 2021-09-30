import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class SheetBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacers.h32,
        Center(
          child: Container(
            height: 5.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Palette.primaryDark,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
        Spacers.h32,
      ],
    );
  }
}
