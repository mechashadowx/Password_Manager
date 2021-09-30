import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';
import 'package:flutter/material.dart';

class PasswordLength extends StatefulWidget {
  final int length;
  final Function add;
  final Function sub;

  PasswordLength({
    required this.length,
    required this.add,
    required this.sub,
  });

  @override
  _PasswordLengthState createState() => _PasswordLengthState();
}

class _PasswordLengthState extends State<PasswordLength> {
  static const _normalState = 'normal';
  static const _changeLengthState = 'change_length';

  String state = _normalState;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(
        milliseconds: 250,
      ),
      child: state == _changeLengthState ? changeLengthState() : normalState(),
    );
  }

  Widget normalState() {
    return lengthContainer(state == _normalState);
  }

  Widget changeLengthState() {
    final _sizedBox = const SizedBox(width: 30);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.sub as void Function()?,
          child: Icon(
            FontAwesome5.arrow_alt_circle_down,
            size: 32,
          ),
        ),
        _sizedBox,
        lengthContainer(state == _normalState),
        _sizedBox,
        GestureDetector(
          onTap: widget.add as void Function()?,
          child: Icon(
            FontAwesome5.arrow_alt_circle_up,
            size: 32,
          ),
        ),
      ],
    );
  }

  Widget lengthContainer(bool active) {
    final _containerColor =
        !active ? Palette.secondaryLight : Palette.primaryDark;
    final _textColor = active ? Palette.secondaryLight : Palette.primaryDark;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (state == _normalState) {
            state = _changeLengthState;
          } else {
            state = _normalState;
          }
        });
      },
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: _containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.length.toString(),
            style: TextStyle(
              color: _textColor,
              fontSize: Font.h4,
            ),
          ),
        ),
      ),
    );
  }
}
