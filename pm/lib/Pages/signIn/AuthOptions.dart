import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';

class AuthOptions extends StatelessWidget {
  final controller;

  AuthOptions({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Palette.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25),
          topRight: const Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Authenticate',
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h3,
              ),
            ),
          ),
          option('SMS'),
          option('Google Authenticator'),
        ],
      ),
    );
  }

  option(optionName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller(optionName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionName,
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h4,
              ),
            ),
            Icon(
              FontAwesome5.caret_right,
              color: Palette.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
