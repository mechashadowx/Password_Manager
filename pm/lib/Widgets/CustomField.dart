import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pm/UI/ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pm/Widgets/CustomContainer.dart';

class CustomField extends StatefulWidget {
  final Function onChange;
  final String? name, hint, initialValue;
  final bool isValid, obscureText;
  final Widget? mid, trailing, bottom;
  final TextEditingController? controller;

  CustomField({
    required this.name,
    required this.onChange,
    required this.isValid,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.initialValue,
    this.mid,
    this.trailing,
    this.bottom,
  });

  @override
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  FocusNode node = FocusNode();
  Color borderColor = Palette.secondaryLight;

  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    node.addListener(controller);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        if (!visible) {
          node.unfocus();
        }
      }
    });
  }

  void controller() {
    setState(() {
      borderColor =
          (node.hasFocus ? Palette.primaryDark : Palette.secondaryLight);
    });
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomContainer(
            borderColor: borderColor,
            child: Row(
              children: [
                Container(
                  width: (size.width - 40.0) * 0.30,
                  margin: EdgeInsets.only(right: 8.0),
                  child: AutoSizeText(
                    widget.name!,
                    style: TextStyle(
                      fontSize: Font.h4,
                      color: (widget.isValid
                          ? Palette.primaryDark
                          : Palette.secondaryDark),
                    ),
                    maxLines: 1,
                    minFontSize: 4.0,
                  ),
                ),
                if (widget.mid != null) widget.mid!,
                if (widget.mid != null) const SizedBox(width: 4.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 5.0),
                    child: TextFormField(
                      onChanged: (input) {
                        widget.onChange(input);
                      },
                      initialValue: widget.initialValue,
                      obscureText: widget.obscureText,
                      maxLines: 1,
                      focusNode: node,
                      controller: widget.controller,
                      cursorColor: Palette.primaryDark,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hint,
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
                ),
                if (widget.trailing != null) widget.trailing!,
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          if (widget.bottom != null) Spacers.h8,
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }
}
