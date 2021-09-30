import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';

class InfoContainer extends StatefulWidget {
  final bool isPassword, allowCopy;
  final String? title, info;

  InfoContainer({
    required this.title,
    required this.info,
    this.isPassword = false,
    this.allowCopy = true,
  });

  @override
  _InfoContainerState createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  static const double fieldIconSize = 20.0;

  late bool isPasswordShown;

  @override
  void initState() {
    super.initState();
    isPasswordShown = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Widget passwordIcon = Container(
      height: fieldIconSize,
      width: fieldIconSize,
      child: Icon(
        isPasswordShown ? FontAwesome5.eye : FontAwesome5.eye_slash,
        color: isPasswordShown ? Palette.primaryDark : Palette.secondaryDark,
        size: fieldIconSize,
      ),
    );
    String? showInfo = '';
    if (!isPasswordShown) {
      int n = widget.info!.length;
      showInfo = showInfo.padRight(n, '•');
    } else {
      showInfo = widget.info;
    }

    return GestureDetector(
      onLongPress: () {
        if (widget.allowCopy) {
          Toast.showCopied(context, widget.info!);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: CustomContainer(
        child: Row(
          children: [
            Container(
              width: (size.width - 40.0) * 0.30,
              margin: EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                widget.title!,
                style: TextStyle(
                  fontSize: Font.h4,
                  color: Palette.primaryDark,
                ),
                maxLines: 1,
                minFontSize: 4.0,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                showInfo!,
                style: TextStyle(
                  fontSize: Font.h4,
                  color: Palette.primaryDark,
                ),
                maxLines: 1,
                minFontSize: 4.0,
              ),
            ),
            if (widget.isPassword)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordShown = !isPasswordShown;
                  });
                },
                child: passwordIcon,
              ),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
