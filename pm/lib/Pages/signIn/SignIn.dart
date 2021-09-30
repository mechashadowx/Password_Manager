import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/signIn/signIn.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../pages.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static const double fieldIconSize = 20.0;

  late CurrentUser user;

  bool isPasswordShown = false;
  bool isLoading = false;

  String username = '';
  String password = '';

  var otpType = CurrentUser.smsOtp;

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

  void usernameController(String input) {
    setState(() {
      username = input;
    });
  }

  void passwordController(String input) {
    setState(() {
      password = input;
    });
  }

  isValidInput() {
    if (!Validator.isUsername(username)) {
      Toast.showInfo(context, 'Invalid Username');
    } else if (!Validator.isPassword(password)) {
      Toast.showInfo(context, 'Invalid Password');
    } else {
      return true;
    }
    return false;
  }

  requestOtp() async {
    if (otpType == CurrentUser.googleOtp) {
      openOtpPage();
      return;
    }
    bool success = await user.requestOtpOfType(otpType);
    turnLoadingOff();
    if (success) {
      openOtpPage();
    } else {
      Toast.showSomethingWentWrong(context);
    }
  }

  getSignInState() async {
    return await user.signIn();
  }

  authOptionsController(option) async {
    Navigator.pop(context);
    if (option == 'SMS') {
      otpType = CurrentUser.smsOtp;
    } else {
      otpType = CurrentUser.googleOtp;
    }
    turnLoadingOn();
    await requestOtp();
  }

  showAuthOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AuthOptions(
          controller: authOptionsController,
        );
      },
    );
  }

  checkSignInState(state) async {
    if (state == SignInState.allowed) {
      await user.getAllAccounts();
      goToHomePage();
    } else if (state == SignInState.userNotFound) {
      turnLoadingOff();
      Toast.showSomethingWentWrong(context);
    } else if (state == SignInState.needPhoneAuth) {
      await user.requestOtpOfType(CurrentUser.smsOtp);
      openOtpPage();
    } else if (state == SignInState.firstTimeDevice) {
      turnLoadingOff();
      showAuthOptions();
    } else {
      assert(false);
    }
  }

  signIn() async {
    if (!isValidInput()) return;
    user.fillSignInInfo(username, password);
    turnLoadingOn();
    var signInState = await getSignInState();
    await checkSignInState(signInState);
  }

  openOtpPage() {
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(
        context,
        Otp(otpType: otpType),
      ),
    );
  }

  goToHomePage() {
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(
        context,
        HomePage(),
      ),
    );
  }

  goToForgotPassword() {
    Navigator.push(
      context,
      CustomTransitions.fadeIn(
        context,
        ForgotPassword(),
      ),
    );
  }

  goToSignUp() {
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(
        context,
        InfoSection(),
      ),
    );
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

    return BaseScaffold(
      header: 'Sign In',
      subHeader: 'Welcome back.',
      isLoading: isLoading,
      appBarIcon: FontAwesome5.times,
      widgets: [
        CustomField(
          name: 'Username',
          hint: 'admin123',
          onChange: usernameController,
          isValid: Validator.isUsername(username),
        ),
        CustomField(
          name: 'Password',
          hint: 'm1X!?08%3X2Bu&a',
          onChange: passwordController,
          isValid: Validator.isPassword(password),
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
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: goToForgotPassword,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: Palette.secondaryDark,
                  fontSize: Font.h5,
                ),
              ),
            ),
          ),
        ),
        Spacers.h32,
        OtherOption(
          action: goToSignUp,
          question: 'Don’t have an account?',
          otherOption: 'Sign Up',
        ),
      ],
      bottom: FAB(icon: FontAwesome5.sign_in_alt, onPress: signIn),
    );
  }
}
