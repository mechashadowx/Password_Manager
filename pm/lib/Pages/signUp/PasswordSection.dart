import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class PasswordSection extends StatefulWidget {
  @override
  _PasswordSectionState createState() => _PasswordSectionState();
}

class _PasswordSectionState extends State<PasswordSection> {
  static const double fieldIconSize = 20.0;
  final specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  late CurrentUser user;

  bool isPasswordShown = false;

  String password = '';
  String confirmPassword = '';
  String hint = '';

  bool isValidPassword = false;
  bool isValidConfirmPassword = false;
  bool isValidHint = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
  }

  turnLoadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  turnLoadingOff() {
    setState(() {
      isLoading = false;
    });
  }

  checkPasswordLength() {
    return password.length > 11;
  }

  checkUpperCaseInPassword() {
    return password.contains(RegExp(r'[A-Z]'));
  }

  checkLowerCaseInPassword() {
    return password.contains(RegExp(r'[a-z]'));
  }

  checkDigitInPassword() {
    return password.contains(RegExp(r'[0-9]'));
  }

  checkSpecialCharInPassword() {
    return password.contains(specialChars);
  }

  checkAllPasswordConditions() {
    final hasRequiredLength = checkPasswordLength();
    final hasUpperCase = checkUpperCaseInPassword();
    final hasLowerCase = checkLowerCaseInPassword();
    final hasDigit = checkDigitInPassword();
    final hasSpecialChar = checkSpecialCharInPassword();
    isValidPassword = hasRequiredLength &&
        hasUpperCase &&
        hasLowerCase &&
        hasDigit &&
        hasSpecialChar;
  }

  void passwordController(String input) {
    setState(() {
      password = input;
      checkAllPasswordConditions();
    });
  }

  void confirmPasswordController(String input) {
    confirmPassword = input;
    setState(() {
      isValidConfirmPassword = (confirmPassword == password);
    });
  }

  void hintController(String input) {
    hint = input;
    setState(() {
      isValidHint = Validator.isHint(hint);
    });
  }

  isValidInput() {
    if (!isValidPassword) {
      Toast.showInfo(context, 'Invalid Password');
    } else if (!isValidConfirmPassword) {
      Toast.showInfo(context, 'Password not match');
    } else if (!isValidHint) {
      Toast.showInfo(context, 'The hint is required');
    } else {
      return true;
    }
    return false;
  }

  signUp() async {
    return await user.signUp();
  }

  next() async {
    if (hint == password) {
      Toast.showInfo(context, 'Bad Hint');
      return;
    }
    if (!isValidInput()) return;
    user.fillPassword(password, hint);
    turnLoadingOn();
    bool success = await signUp();
    if (success) {
      await user.requestOtpOfType(CurrentUser.smsOtp);
      turnLoadingOff();
      openOtpPage();
    } else {
      Toast.showSomethingWentWrong(context);
    }
  }

  openOtpPage() {
    Navigator.pushAndRemoveUntil(
      context,
      CustomTransitions.fadeIn(
        context,
        Otp(otpForSignUp: true),
      ),
      (route) => false,
    );
  }

  back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget passwordIcon = Container(
      height: fieldIconSize,
      width: fieldIconSize,
      child: Icon(
        isPasswordShown ? FontAwesome5.eye : FontAwesome5.eye_slash,
        color: isPasswordShown ? Palette.primaryDark : Palette.secondaryDark,
        size: fieldIconSize,
      ),
    );
    final isPasswordConditions = [
      checkPasswordLength(),
      checkUpperCaseInPassword(),
      checkLowerCaseInPassword(),
      checkDigitInPassword(),
      checkSpecialCharInPassword(),
    ];
    final textPasswordConfitions = [
      '12 symbols',
      'uppercase',
      'lowercase',
      'digit',
      'special char',
    ];

    return BaseScaffold(
      isLoading: isLoading,
      header: 'Password',
      subHeader: 'We won\'t be able to change this password so be careful',
      widgets: [
        CustomField(
          name: 'Password',
          hint: 'm1X!?08%3X2Bu&a',
          onChange: passwordController,
          isValid: isValidPassword,
          obscureText: !isPasswordShown,
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordShown = !isPasswordShown;
              });
            },
            child: passwordIcon,
          ),
          bottom: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: Font.h5),
                children: List.generate(9, (text) {
                  if (text % 2 == 1) {
                    return TextSpan(
                      text: ' • ',
                      style: TextStyle(
                        color: Palette.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }
                  int condition = (text ~/ 2);
                  if (isPasswordConditions[condition]) {
                    return TextSpan(
                      text: textPasswordConfitions[condition],
                      style: TextStyle(
                        color: Palette.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }
                  return TextSpan(
                    text: textPasswordConfitions[condition],
                    style: TextStyle(color: Palette.secondaryDark),
                  );
                }),
              ),
            ),
          ),
        ),
        CustomField(
          name: 'Confirm Password',
          hint: 'm1X!?08%3X2Bu&a',
          onChange: confirmPasswordController,
          isValid: isValidConfirmPassword,
          obscureText: true,
        ),
        CustomField(
          name: 'Hint',
          hint: 'I Know',
          onChange: hintController,
          isValid: isValidHint,
          bottom: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '* This hint won\'t be encrypted.',
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h5,
              ),
            ),
          ),
        ),
      ],
      bottom: FAB(icon: FontAwesome5.arrow_right, onPress: next),
    );
  }
}
