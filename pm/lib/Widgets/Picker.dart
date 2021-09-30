import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';

class Picker extends StatefulWidget {
  final int id;
  final bool filled;
  final bool height;
  final String? hint;
  final String value;
  final String title;
  final Function pick;
  final int? pickedOption;
  final List<String> options;
  final beforePicking;

  Picker({
    required this.id,
    required this.title,
    required this.pick,
    required this.options,
    this.height = false,
    this.filled = false,
    this.value = '',
    this.pickedOption,
    this.hint,
    this.beforePicking,
  });

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  void showOptions() {
    List<Widget> widgets = [
      Text(
        widget.title,
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h3,
        ),
      ),
      Spacers.h32,
    ];
    widgets.addAll(
      List.generate(widget.options.length, (option) {
        double padding = (option == widget.options.length - 1 ? 0 : 16);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
            widget.pick(widget.id, option);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: padding),
            child: CustomOption(
              option: widget.options[option],
              picked: widget.pickedOption == option,
            ),
          ),
        );
      }),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 105.0 +
              36.0 * widget.options.length +
              (widget.height ? 30.0 : 0.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Palette.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String value = (widget.value != '' ? ' - ' + widget.value : '');
    Color color = (value == '' ? Palette.secondaryDark : Palette.primaryDark);
    return GestureDetector(
      onTap: () async {
        if (widget.beforePicking != null) await widget.beforePicking();
        showOptions();
      },
      child: CustomContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              widget.hint == null ? widget.title + value : widget.hint!,
              style: TextStyle(
                color: color,
                fontSize: Font.h4,
              ),
            ),
            Icon(
              FontAwesome5.caret_right,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomOption extends StatelessWidget {
  final String option;
  final bool picked;

  CustomOption({
    required this.option,
    this.picked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            option,
            style: TextStyle(
              color: Palette.primaryDark,
              fontSize: Font.h4,
            ),
          ),
          dot(),
        ],
      ),
    );
  }

  Widget dot() {
    if (!picked) {
      return Container(
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
          color: Palette.primaryLight,
          border: Border.all(
            width: 2.0,
            color: Palette.secondaryDark,
          ),
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: Palette.primaryLight,
              border: Border.all(
                width: 2.0,
                color: Palette.primaryDark,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
              color: Palette.primaryDark,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }
  }
}
