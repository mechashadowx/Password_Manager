import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Pages/profile/profile.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Profile extends StatefulWidget {
  static final String id = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late CurrentUser user;
  bool isLoading = false;
  String hint = '', password = '', newPassword = '';

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

  Future changePassword() async {
    Navigator.pop(context);
    turnLoadingOn();
    if (password == user.password) {
      bool success = await user.changePassword(newPassword);
      if (success) {
        Toast.showDone(context);
      } else {
        Toast.showSomethingWentWrong(context);
      }
    } else {
      wrongPassword();
    }
    turnLoadingOff();
  }

  Future changeHint() async {
    Navigator.pop(context);
    turnLoadingOn();
    if (password == user.password) {
      bool success = await user.changeHint(hint);
      if (success) {
        Toast.showDone(context);
      } else {
        Toast.showSomethingWentWrong(context);
      }
    } else {
      wrongPassword();
    }
    turnLoadingOff();
  }

  void wrongPassword() {
    Toast.showInfo(context, 'Wrong Password');
  }

  void hintController(String input) {
    setState(() {
      hint = input;
    });
  }

  void passwordController(String input) {
    setState(() {
      password = input;
    });
  }

  void newPasswordController(String input) {
    setState(() {
      newPassword = input;
    });
  }

  void launchGoogleAuthOtp() async {
    await launch(user.googleAuthOtpLink!);
  }

  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(
      builder: (context, user, child) {
        return BaseScaffold(
          header: 'Profile',
          subHeader: 'Here you can manage you info.',
          isLoading: isLoading,
          widgets: [
            Center(
              child: AutoSizeText(
                user.username!,
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h2,
                  fontWeight: FontWeight.w700,
                ),
                minFontSize: 4.0,
                maxLines: 1,
              ),
            ),
            Center(
              child: AutoSizeText(
                user.email!,
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h4,
                ),
                minFontSize: 4.0,
                maxLines: 1,
              ),
            ),
            Spacers.customSpacer(50.0),
            InfoChanger(
              infoName: 'Password',
              infoController: newPasswordController,
              passwordController: passwordController,
              onSave: changePassword,
            ),
            SizedBox(),
            InfoChanger(
              infoName: 'Hint',
              infoController: hintController,
              passwordController: passwordController,
              onSave: changeHint,
            ),
            SizedBox(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (user.googleAuthOtpLink == null) {
                  turnLoadingOn();
                  await user.requestOtpOfType(CurrentUser.googleOtp);
                  turnLoadingOff();
                }
                openGoogleAuthSheet();
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Google Authenticator',
                      style: TextStyle(
                        color: Palette.primaryDark,
                        fontSize: Font.h4,
                      ),
                    ),
                    Icon(
                      FontAwesome5.caret_right,
                      size: Font.h4,
                    ),
                  ],
                ),
              ),
            ),
          ],
          bottom: FAB(icon: FontAwesome5.check, onPress: back),
        );
      },
    );
  }

  void openGoogleAuthSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SheetBar(),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Google Authenticator:',
                    style: TextStyle(
                      color: Palette.primaryDark,
                      fontSize: Font.h3,
                    ),
                  ),
                ),
              ),
              qrCodeUrl(),
              Spacers.h16,
              Spacers.h8,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scan    ',
                    style: TextStyle(
                      color: Palette.primaryDark,
                      fontSize: Font.h4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'or',
                    style: TextStyle(
                      color: Palette.primaryDark,
                      fontSize: Font.h5,
                    ),
                  ),
                  Text(
                    '    Click',
                    style: TextStyle(
                      color: Palette.primaryDark,
                      fontSize: Font.h4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget qrCodeUrl() {
    return GestureDetector(
      onTap: () async {
        await launch(user.googleAuthOtpLink!);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Palette.primaryDark,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: QrImage(
          data: user.googleAuthOtpLink!,
          version: QrVersions.auto,
          size: 175.0,
        ),
      ),
    );
  }
}
