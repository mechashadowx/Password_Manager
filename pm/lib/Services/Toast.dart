import 'package:clipboard/clipboard.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class Toast {
  static const duration = Duration(seconds: 1);
  static const bottomPadding = 120.0;

  static flashText(info) {
    return Text(
      info,
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h4,
      ),
    );
  }

  static void showInfo(BuildContext context, String info) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          margin: EdgeInsets.only(bottom: bottomPadding),
          alignment: Alignment.bottomCenter,
          backgroundColor: Colors.transparent,
          child: flashText(info),
        );
      },
    );
  }

  static showCopied(BuildContext context, String info) {
    FlutterClipboard.copy(info);
    showInfo(context, 'Copied');
  }

  static showDoubleTapToConfirm(BuildContext context) {
    showInfo(context, 'Double Tap To Confirm');
  }

  static showSomethingWentWrong(BuildContext context) {
    showInfo(context, 'Something went wrong');
  }

  static showDone(BuildContext context) {
    showInfo(context, 'Done!');
  }
}
