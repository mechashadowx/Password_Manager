import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/profile/profile.dart';
import 'package:pm/UI/ui.dart';

class InfoChanger extends StatelessWidget {
  final String infoName;
  final Function infoController, passwordController, onSave;

  InfoChanger({
    required this.infoName,
    required this.infoController,
    required this.passwordController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => openInfoUpdateBottomSheet(context),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Change $infoName',
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h4,
              ),
            ),
            Icon(
              FontAwesome5.caret_right,
              size: Font.h4,
            ),
          ],
        ),
      ),
    );
  }

  void openInfoUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return InfoUpdateBottomSheet(
          infoName: infoName,
          onSave: onSave,
          onInfoChange: infoController,
          onPasswordChange: passwordController,
        );
      },
    );
  }
}
