import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/UI/ui.dart';

class HomeDrawerHeader extends StatelessWidget {
  final navigator;
  final username, email;

  HomeDrawerHeader({
    required this.email,
    required this.username,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              userIcon(),
              const SizedBox(width: 16.0),
              userInfoWidget(size),
            ],
          ),
          goToNotificationPageOption(),
        ],
      ),
    );
  }

  userIcon() {
    return GestureDetector(
      onTap: () => navigator(Profile.id),
      child: Icon(
        FontAwesome5.user_circle,
        color: Palette.primaryDark,
        size: 40.0,
      ),
    );
  }

  usernameWidget() {
    return AutoSizeText(
      username,
      style: TextStyle(
        color: Palette.primaryDark,
        fontSize: Font.h4,
      ),
      maxLines: 1,
      minFontSize: 4.0,
    );
  }

  emailWidget() {
    return AutoSizeText(
      email,
      style: TextStyle(
        color: Palette.secondaryDark,
        fontSize: Font.h5,
      ),
      maxLines: 1,
      minFontSize: 4.0,
    );
  }

  userInfoWidget(size) {
    return Container(
      width: size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          usernameWidget(),
          emailWidget(),
        ],
      ),
    );
  }

  goToNotificationPageOption() {
    return GestureDetector(
      onTap: () => navigator(Notifications.id),
      child: Icon(
        FontAwesome5.bell,
        color: Palette.secondaryDark,
      ),
    );
  }
}
