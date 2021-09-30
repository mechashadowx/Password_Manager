import 'package:flutter/material.dart';
import 'package:pm/Models/models.dart';
import 'package:provider/provider.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/Pages/search/search.dart';

class Search extends StatefulWidget {
  static final String id = 'Search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late CurrentUser user;
  bool isLoading = false;

  List<Widget> websites = [];
  List<String?> websitesNames = [];
  late Map<String?, List<Account>> accountsMap;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
    accountsMap = user.getAccountsMap();
  }

  void onChange(String input) {
    turnLoadingOn();
    setState(() {
      websitesNames = user
          .getWebsitesNames()
          .where((name) => name!.contains(input))
          .toList();
      websites = [];
      for (String? name in websitesNames) {
        websites.add(
          WebsiteListTile(
            websiteName: name,
            numberOfAccounts: accountsMap[name]!.length,
            isWarning: user.numberOfWarningsInWebsite(name) != 0,
          ),
        );
      }
    });
    turnLoadingOff();
  }

  void turnLoadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  void turnLoadingOff() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: 'Search',
      isLoading: isLoading,
      widgets: [
        SearchField(onChange: onChange),
        const SizedBox(),
        for (Widget website in websites) website,
      ],
    );
  }
}
