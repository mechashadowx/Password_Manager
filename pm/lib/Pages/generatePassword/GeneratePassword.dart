import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/generatePassword/generatePassword.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';

class GeneratePassword extends StatefulWidget {
  static final String id = 'Generate Password';

  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  late String password;
  int passwordLength = 15;

  @override
  void initState() {
    super.initState();
    password = PasswordGenerator.generate();
  }

  void generate() {
    setState(() {
      password = PasswordGenerator.generate(length: passwordLength);
    });
  }

  void copy() {
    Toast.showCopied(context, password);
  }

  void addOnePasswordLength() {
    if (passwordLength == 20) {
      Toast.showInfo(context, '20 is The Maximum');
      return;
    }
    setState(() {
      passwordLength++;
    });
    generate();
  }

  void subOnePasswordLength() {
    if (passwordLength == 8) {
      Toast.showInfo(context, '8 is The Minimum');
      return;
    }
    setState(() {
      passwordLength--;
    });
    generate();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: 'Generate Password',
      subHeader: 'You can use this tool to generate strong passwords.',
      widgets: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: CustomContainer(
            child: Center(
              child: AutoSizeText(
                password,
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h3,
                  fontWeight: FontWeight.w700,
                ),
                minFontSize: 4.0,
                maxLines: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        PasswordLength(
          length: passwordLength,
          add: addOnePasswordLength,
          sub: subOnePasswordLength,
        ),
      ],
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FAB(
            icon: FontAwesome5.sync_alt,
            onPress: generate,
          ),
          const SizedBox(width: 100.0),
          FAB(
            icon: FontAwesome5.copy,
            onPress: copy,
          ),
        ],
      ),
    );
  }
}
