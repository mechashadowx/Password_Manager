import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/otp/otp.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Otp extends StatefulWidget {
  static const maxNumberOfTries = 3;

  final otpType;
  final otpForSignUp;

  Otp({
    this.otpType = CurrentUser.smsOtp,
    this.otpForSignUp = false,
  });

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late var user;
  var isLoading = false;
  var otp = '';
  var tries = 0;

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

  otpController(input) {
    otp = input;
  }

  resendOtp() async {
    turnLoadingOn();
    bool? success = await user.requestOtpOfType(widget.otpType);
    if (success == true) {
      Toast.showDone(context);
    } else {
      Toast.showSomethingWentWrong(context);
    }
    turnLoadingOff();
  }

  toastNumberOfLeftTries(numberOfLeftTries) {
    if (numberOfLeftTries <= 0) {
      Toast.showInfo(context, 'Try tomorrow');
    } else if (numberOfLeftTries == 1) {
      Toast.showInfo(context, 'You have one try left');
    } else {
      Toast.showInfo(context, 'You have two tries left');
    }
  }

  chackNumberOfLeftTries() {
    var numberOfLeftTries = Otp.maxNumberOfTries - tries;
    toastNumberOfLeftTries(numberOfLeftTries);
  }

  confirmOtp() async {
    if (otp.length < 6 || tries == 3) return;
    tries++;
    turnLoadingOn();
    bool success = await user.checkOtpOfType(widget.otpType, otp);
    if (!success) {
      chackNumberOfLeftTries();
    } else {
      await navigate();
    }
    turnLoadingOff();
  }

  getGoogleAuthOtp() async {
    await launch(user.googleAuthOtpLink);
  }

  navigate() async {
    if (widget.otpForSignUp) {
      goToSignIn();
    } else {
      await user.getAllAccounts();
      goToHomePage();
    }
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

  goToSignIn() {
    Navigator.pushReplacement(
      context,
      CustomTransitions.fadeIn(
        context,
        SignIn(),
      ),
    );
  }

  back() {
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
    var header = '', subHeader = '';
    if (widget.otpType == CurrentUser.smsOtp) {
      header = 'SMS Message';
      subHeader =
          'Chech your SMS messages. We’ve sent you the OTP at ${user.phone} .';
    } else {
      header = 'Google Authenticator';
      subHeader = 'Check your Google Authenticator account.';
    }

    return BaseScaffold(
      header: header,
      subHeader: subHeader,
      appBarAction: back,
      isLoading: isLoading,
      widgets: [
        OtpWithKeyboard(otpController: otpController),
        if (widget.otpType == CurrentUser.smsOtp)
          OtherOption(
            action: resendOtp,
            question: 'Didn’t receive any code?',
            otherOption: 'Re-send code',
          ),
      ],
      bottom: FAB(icon: FontAwesome5.check, onPress: confirmOtp),
    );
  }
}
