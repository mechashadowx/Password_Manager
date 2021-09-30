import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/customListTile/customListTile.dart';

class WebsiteListTile extends StatelessWidget {
  final bool isWarning;
  final String? websiteName;
  final int numberOfAccounts;

  WebsiteListTile({
    required this.websiteName,
    required this.numberOfAccounts,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileContainer(
      isWarning: isWarning,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              WebsitesIcons.getWebsiteIcon(websiteName),
              color: Palette.primaryDark,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              websiteNameWidget(),
              numberOfAccountsWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget websiteNameWidget() {
    return Expanded(
      child: AutoSizeText(
        Formatter.websiteListTile(websiteName!),
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h4,
        ),
        maxLines: 1,
        minFontSize: 4.0,
      ),
    );
  }

  Widget numberOfAccountsWidget() {
    final numberOfAccountsText =
        Formatter.numberWithName('Account', numberOfAccounts);

    return Text(
      numberOfAccountsText,
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h5,
      ),
    );
  }
}
