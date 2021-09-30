import 'package:flutter/material.dart';

class CustomTransitions {
  static PageRouteBuilder fadeIn(BuildContext context, Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secAnimation,
      ) {
        return child;
      },
    );
  }
}
