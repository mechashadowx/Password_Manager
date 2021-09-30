import 'package:flutter/material.dart';

class InvisibleKeyboard extends StatelessWidget {
  final onChange;
  final focusNode;

  InvisibleKeyboard({
    required this.onChange,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: 0.0,
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.85),
        child: TextField(
          onChanged: onChange,
          style: TextStyle(fontSize: 1.0),
          decoration: InputDecoration(
            counter: Offstage(),
            border: InputBorder.none,
          ),
          maxLength: 6,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
