import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class WebsitesIcons {
  static const notFound = 'notFound';

  static const Map<String, IconData> websiteIcon = {
    'www.google.com': FontAwesome5.google,
    'www.facebook.com': FontAwesome5.facebook_f,
    'www.twitter.com': FontAwesome5.twitter,
    'www.github.com': FontAwesome5.github,
    notFound: FontAwesome5.at,
  };

  static getWebsiteIcon(String? website) {
    website = websiteIcon.containsKey(website) ? website : notFound;
    return websiteIcon[website!];
  }
}
