import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  CustomContainer({
    required this.child,
    this.borderColor = Palette.secondaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Palette.secondaryLight,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
            color: Color(0x25000000),
          ),
        ],
      ),
      child: child,
    );
  }
}
