import 'package:pm/UI/ui.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function onChange;

  SearchField({
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Palette.primaryLight,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Palette.primaryDark),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
            color: Color(0x25000000),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, right: 5.0),
        child: TextFormField(
          onChanged: (input) {
            onChange(input);
          },
          maxLines: 1,
          cursorColor: Palette.primaryDark,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'www.example.com',
            hintStyle: TextStyle(
              color: Palette.secondaryDark,
              fontSize: Font.h4,
            ),
            contentPadding: EdgeInsets.only(bottom: 9.0),
          ),
          style: TextStyle(
            color: Palette.primaryDark,
            fontSize: Font.h4,
          ),
        ),
      ),
    );
  }
}
