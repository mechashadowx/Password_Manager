import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late CurrentUser user;

  bool isLoading = false;

  String username = '';

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

  bool isValidUsername() {
    return Validator.isUsername(username);
  }

  void usernameController(String input) {
    setState(() {
      username = input;
    });
  }

  void sendHint() async {
    if (!isValidUsername()) {
      Toast.showInfo(context, 'Invalid Username');
    } else {
      turnLoadingOn();
      user.clearCurrentUserInfo();
      await user.sendHint(username);
      turnLoadingOff();
      Toast.showInfo(context, 'Check Your Email');
    }
  }

  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isLoading: isLoading,
      header: 'Forgot Password',
      subHeader:
          'Enter your username and we will send your hint to your email.',
      widgets: [
        CustomField(
          name: 'Username',
          hint: 'user123',
          onChange: usernameController,
          isValid: isValidUsername(),
        ),
      ],
      bottom: FAB(icon: FontAwesome5.paper_plane, onPress: sendHint),
    );
  }
}
