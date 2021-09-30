import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Services/Toast.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';

class InfoUpdateBottomSheet extends StatelessWidget {
  final String infoName;
  final Function onSave, onInfoChange, onPasswordChange;

  InfoUpdateBottomSheet({
    required this.infoName,
    required this.onSave,
    required this.onInfoChange,
    required this.onPasswordChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SheetBar(),
              title(),
              confirmPasswordField(),
              changeInfoField(),
            ],
          ),
          bottom(context),
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Change $infoName:',
          style: TextStyle(
            color: Palette.primaryDark,
            fontSize: Font.h3,
          ),
        ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomField(
        name: 'Password',
        isValid: true,
        onChange: (String input) => onPasswordChange(input),
        hint: '',
      ),
    );
  }

  Widget changeInfoField() {
    return CustomField(
      name: 'New $infoName',
      isValid: true,
      onChange: (String input) => onInfoChange(input),
      hint: '',
    );
  }

  Widget bottom(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: confirmButton(context),
    );
  }

  Widget confirmButton(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onSave as void Function()?,
      child: FAB(
        icon: FontAwesome5.check,
        onPress: () => Toast.showDoubleTapToConfirm(context),
      ),
    );
  }
}
