import 'package:flutter/material.dart';
import 'package:pm/Pages/homePage/homePage.dart';
import 'package:pm/UI/ui.dart';

class HomePageDrawer extends StatelessWidget {
  final user;
  final signOut;
  final navigator;

  HomePageDrawer({
    required this.user,
    required this.signOut,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    final pages = HomePage.pages;

    return DrawerContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeDrawerHeader(
                username: user.username,
                email: user.email,
                navigator: navigator,
              ),
              drawerPagesBuilder(pages),
            ],
          ),
          signOutOptionWidget(),
          versionWidget(),
        ],
      ),
    );
  }

  drawerPageWidget(String option, bool opend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0, left: 20.0),
      child: GestureDetector(
        onTap: () => navigator(option),
        child: Text(
          option,
          style: TextStyle(
            color: (opend ? Palette.primaryDark : Palette.secondaryDark),
            fontSize: Font.h4,
            fontWeight: (opend ? FontWeight.w700 : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  drawerPagesBuilder(pages) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(pages.length, (option) {
          return drawerPageWidget(pages[option], option == 0);
        }),
      ),
    );
  }

  signOutOptionWidget() {
    return Center(
      child: GestureDetector(
        onTap: signOut,
        child: Text(
          'Sign Out',
          style: TextStyle(
            color: Palette.secondaryDark,
            fontSize: Font.h4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  versionWidget() {
    return Center(
      child: Text(
        'Version 0.1.0',
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h4,
        ),
      ),
    );
  }
}
