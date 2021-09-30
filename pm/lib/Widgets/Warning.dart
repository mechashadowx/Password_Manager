import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class Warning extends StatelessWidget {
  final String warning;

  Warning({
    required this.warning,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: (size.width - 96.0),
      child: AutoSizeText(
        warning,
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h4,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 2,
      ),
    );
  }
}
