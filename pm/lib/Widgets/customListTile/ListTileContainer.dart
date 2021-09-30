import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';

class ListTileContainer extends StatelessWidget {
  final child;
  final isWarning;

  ListTileContainer({
    required this.child,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 70.0,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Palette.secondaryLight,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
              color: Color(0x25000000),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              child,
              warningIcon(),
            ],
          ),
        ),
      ),
    );
  }

  warningIcon() {
    return Icon(
      isWarning ? FontAwesome5.exclamation_circle : FontAwesome5.check_circle,
      color: Palette.primaryDark,
      size: 32.0,
    );
  }
}
