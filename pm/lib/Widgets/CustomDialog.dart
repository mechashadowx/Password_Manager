import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';

class CustomDialog extends StatelessWidget {
  final Widget info;
  final String title;
  final Function yes, no;

  CustomDialog({
    required this.title,
    required this.info,
    required this.yes,
    required this.no,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200.0,
      // child: AlertDialog(
      //   backgroundColor: Palette.primaryDark,
      //   title: Center(
      //     child: Text(
      //       title,
      //       style: TextStyle(
      //         color: Palette.primaryLight,
      //         fontSize: Font.h3,
      //       ),
      //     ),
      //   ),
      //   content: Center(child: info),
      //   actions: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         // SmallFAB(icon: FontAwesome5.times, onPress: no),
      //         SizedBox(width: 100.0),
      //         // SmallFAB(icon: FontAwesome5.check, onPress: yes),
      //       ],
      //     ),
      //   ],
      // ),
      height: 200.0,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Palette.primaryDark,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Palette.primaryLight,
              fontSize: Font.h3,
            ),
          ),
          info,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallFAB(icon: FontAwesome5.times, onPress: no),
              SizedBox(width: 100.0),
              SmallFAB(icon: FontAwesome5.check, onPress: yes),
            ],
          ),
        ],
      ),
    );
  }
}

class SmallFAB extends StatelessWidget {
  final IconData icon;
  final Function onPress;

  SmallFAB({
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          color: Palette.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18.0,
            color: Palette.primaryDark,
          ),
        ),
      ),
    );
  }
}
