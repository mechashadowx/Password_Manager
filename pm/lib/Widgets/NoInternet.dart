import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.2),
          child: Column(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: Palette.primaryDark,
                size: 200.0,
              ),
              Spacers.h16,
              Text(
                'No Internet!',
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacers.h16,
              Text(
                'Please check your internet connection',
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
