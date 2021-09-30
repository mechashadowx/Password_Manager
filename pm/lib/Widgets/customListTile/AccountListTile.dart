import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/customListTile/customListTile.dart';

class AccountListTile extends StatelessWidget {
  final emailName;
  final isWarning;

  AccountListTile({
    required this.emailName,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileContainer(
      isWarning: isWarning,
      child: emailNameWidget(),
    );
  }

  emailNameWidget() {
    return Expanded(
      child: AutoSizeText(
        emailName,
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h4,
        ),
        maxLines: 1,
        minFontSize: 4.0,
      ),
    );
  }
}
