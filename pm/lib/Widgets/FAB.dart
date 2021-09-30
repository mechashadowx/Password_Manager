import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class FAB extends StatelessWidget {
  final IconData icon;
  final Function onPress;

  FAB({
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Container(
        height: 56.0,
        width: 56.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Palette.primaryDark,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Palette.primaryLight,
          ),
        ),
      ),
    );
  }
}
