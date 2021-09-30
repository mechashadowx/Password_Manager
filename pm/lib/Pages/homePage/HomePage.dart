import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/homePage/homePage.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePageId';

  static const List<String> pages = [
    'Accounts',
    'Search',
    'Notifications',
    'Upload CSV',
    'Generate Password',
    'Profile',
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CurrentUser user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
    isLoading = false;
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

  void addAccount() async {
    Navigator.push(
      context,
      CustomTransitions.fadeIn(
        context,
        EditAccount(accountId: -1),
      ),
    );
  }

  void openWebsite(String? website) {
    Navigator.push(
      context,
      CustomTransitions.fadeIn(
        context,
        Website(website: website),
      ),
    );
  }

  void pushPage(Widget page) {
    Navigator.push(context, CustomTransitions.fadeIn(context, page));
  }

  void navigator(String page) {
    if (page == Search.id) {
      pushPage(Search());
    }
    if (page == Notifications.id) {
      pushPage(Notifications());
    }
    if (page == UploadCSV.id) {
      pushPage(UploadCSV());
    }
    if (page == GeneratePassword.id) {
      pushPage(GeneratePassword());
    }
    if (page == Profile.id) {
      pushPage(Profile());
    }
  }

  Future requestGoogleAuthOtp() async {
    return user.requestOtpOfType(CurrentUser.googleOtp);
  }

  void signOut() {
    user.clearCurrentUserInfo();
    user = CurrentUser();
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(context, SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(
      builder: (context, user, child) {
        final accountsMap = user.getAccountsMap();
        final websites = user.getWebsitesNames();
        final subHeader =
            subHeaderBuilder(websites.length, user.accounts.length);

        return BaseScaffold(
          drawer: HomePageDrawer(
            user: user,
            signOut: signOut,
            navigator: navigator,
          ),
          appBarIcon: FontAwesome5.bars,
          header: 'Accounts',
          subHeader: subHeader,
          isLoading: isLoading,
          withBottomSpace: true,
          widgets: List.generate(websites.length, (i) {
            String? website = websites[i];

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => openWebsite(website),
              child: WebsiteListTile(
                isWarning: user.numberOfWarningsInWebsite(website) != 0,
                websiteName: website,
                numberOfAccounts: accountsMap[website]!.length,
              ),
            );
          }),
          bottom: FAB(icon: FontAwesome5.plus, onPress: addAccount),
        );
      },
    );
  }

  String subHeaderBuilder(int numberOfWebsites, int numberOfAccounts) {
    if (numberOfAccounts == 0) {
      return 'You don\'t have any accounts.';
    } else {
      final websitesCountText =
          Formatter.numberWithName('website', numberOfWebsites);
      final accountsCountText =
          Formatter.numberWithName('account', numberOfAccounts);
      return 'You have $accountsCountText on $websitesCountText.';
    }
  }
}
