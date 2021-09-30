import 'package:flutter/material.dart';

class DrawerContainer extends StatelessWidget {
  final child;

  DrawerContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(25),
          bottomRight: const Radius.circular(25),
        ),
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 30.0,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
