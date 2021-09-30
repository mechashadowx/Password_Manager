import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class OtherOption extends StatelessWidget {
  final Function action;
  final String question;
  final String otherOption;

  OtherOption({
    required this.action,
    required this.question,
    required this.otherOption,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action as void Function()?,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: Font.h4),
          children: [
            TextSpan(
              text: question + '\n',
              style: TextStyle(
                color: Palette.secondaryDark,
              ),
            ),
            TextSpan(
              text: otherOption,
              style: TextStyle(
                color: Palette.primaryDark,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
