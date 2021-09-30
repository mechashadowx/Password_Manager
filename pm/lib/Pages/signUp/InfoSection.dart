import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/Pages/signUp/signUp.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class InfoSection extends StatefulWidget {
  @override
  _InfoSectionState createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  late CurrentUser user;

  String username = '';
  String email = '';
  String phone = '';
  String dialingCode = Validator.nullDialingCode;

  bool isValidUsername = false;
  bool isValidEmail = false;
  bool isValidPhone = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
  }

  void usernameController(String input) {
    username = input;
    setState(() {
      isValidUsername = Validator.isUsername(username);
    });
  }

  void emailController(String input) {
    email = input;
    setState(() {
      isValidEmail = Validator.isEmail(email);
    });
  }

  void phoneController(String input) {
    phone = input;
    setState(() {
      isValidPhone = Validator.isPhone(phone, dialingCode);
    });
  }

  void selectDialingCode(String code) {
    setState(() {
      dialingCode = code;
      isValidPhone = Validator.isPhone(phone, dialingCode);
    });
  }

  void next() {
    if (!isValidUsername) {
      Toast.showInfo(context, 'Invalid Username');
    } else if (!isValidEmail) {
      Toast.showInfo(context, 'Invalid Email');
    } else if (!isValidPhone) {
      Toast.showInfo(context, 'Invalid Phone');
    } else {
      user.fillInfo(username, email, dialingCode + phone.substring(1));
      Navigator.push(
        context,
        CustomTransitions.fadeIn(
          context,
          PasswordSection(),
        ),
      );
    }
  }

  void back() {
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(
        context,
        SignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: 'Sign Up',
      subHeader:
          'Create an account so you can manage all your passwords in a safe place.',
      appBarAction: back,
      widgets: [
        CustomField(
          name: 'Username',
          hint: 'shadow_123',
          onChange: usernameController,
          isValid: isValidUsername,
        ),
        CustomField(
          name: 'Email',
          hint: 'example@axyz.com',
          onChange: emailController,
          isValid: isValidEmail,
        ),
        CustomField(
          name: 'Phone',
          hint: '0000000000',
          onChange: phoneController,
          isValid: isValidPhone,
          mid: GestureDetector(
            onTap: dialingCodePicker,
            child: Text(
              dialingCode,
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h4,
              ),
            ),
          ),
        ),
      ],
      bottom: FAB(icon: FontAwesome5.arrow_right, onPress: next),
    );
  }

  void dialingCodePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SheetBar(),
              Text(
                'Dialing Code',
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h3,
                ),
              ),
              Spacers.h16,
              DialingCodesWidget(
                selectedCode: dialingCode,
                selectDialingCode: selectDialingCode,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DialingCodesWidget extends StatelessWidget {
  final String selectedCode;
  final Function selectDialingCode;

  DialingCodesWidget({
    required this.selectedCode,
    required this.selectDialingCode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: List.generate(DialingCodes.codes.length, (country) {
          String code = DialingCodes.codes[country]['dial_code']!;
          Color color = (code == selectedCode
              ? Palette.primaryDark
              : Palette.secondaryDark);
          FontWeight fontWeight =
              (code == selectedCode ? FontWeight.w700 : FontWeight.normal);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                selectDialingCode(code);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Container(
                    width: 65.0,
                    child: Text(
                      code,
                      style: TextStyle(
                        color: color,
                        fontSize: Font.h4,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                  Spacers.h16,
                  Container(
                    child: Text(
                      DialingCodes.codes[country]['name']!,
                      style: TextStyle(
                        color: color,
                        fontSize: Font.h4,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
