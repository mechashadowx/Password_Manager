import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  final state;
  final accountId;

  EditAccount({
    required this.accountId,
  }) : state = accountId == -1 ? 'Add' : 'Edit';

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final fieldIconSize = 20.0;
  final controller = TextEditingController();

  late CurrentUser user;
  late Account account, newAccount;
  bool isPasswordShown = false, isLoading = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
    account = user.getAccountById(widget.accountId);
    newAccount = Account.copyAccount(account);
    controller.text = newAccount.password!;
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

  void websiteController(String input) {
    setState(() {
      newAccount.website = input;
    });
  }

  void emailController(String input) {
    setState(() {
      newAccount.email = input;
    });
  }

  void passwordController(String input) {
    setState(() {
      newAccount.password = input;
    });
  }

  bool isValidWebsite() {
    return Validator.isWebsite(newAccount.website!);
  }

  bool isValidEmail() {
    return Validator.isEmail(newAccount.email!);
  }

  isValidInput() {
    if (!isValidWebsite()) {
      Toast.showInfo(context, 'Invalid Website');
    } else if (!isValidEmail()) {
      Toast.showInfo(context, 'Invalid Email');
    } else if (newAccount.password!.length == 0) {
      Toast.showInfo(context, 'Invalid Password');
    } else {
      return true;
    }
    return false;
  }

  operationSuccess() {
    Toast.showDone(context);
    Navigator.pop(context);
  }

  operationFaild() {
    Toast.showSomethingWentWrong(context);
  }

  addAccount() async {
    turnLoadingOn();
    var success = await user.addAccount(newAccount);
    if (success)
      operationSuccess();
    else
      operationFaild();
    turnLoadingOff();
  }

  updateAccount() async {
    turnLoadingOn();
    var success = await user.updateAccount(newAccount);
    if (success)
      operationSuccess();
    else
      operationFaild();
    turnLoadingOff();
  }

  bool isNewAccount() {
    if (widget.state == 'Edit' && account.password != newAccount.password) {
      return true;
    }
    if (newAccount.email != account.email ||
        newAccount.website != account.website) {
      return user.isNewAccount(newAccount.website, newAccount.email);
    }
    Toast.showInfo(context, 'You already added this account');
    return false;
  }

  done() async {
    if (!isValidInput()) return;
    if (!isNewAccount()) return;
    turnLoadingOn();
    if (widget.state == 'Add') {
      await addAccount();
    } else {
      await updateAccount();
    }
    turnLoadingOff();
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
      header: '${widget.state == 'Add' ? 'Add' : 'Edit'} Account',
      isLoading: isLoading,
      widgets: [
        CustomField(
          name: 'Website',
          onChange: websiteController,
          isValid: isValidWebsite(),
          hint: 'www.example.com',
          initialValue: account.website,
        ),
        CustomField(
          name: 'Email',
          onChange: emailController,
          isValid: isValidEmail(),
          hint: 'admin@example.com',
          initialValue: account.email,
        ),
        CustomField(
          name: 'Password',
          onChange: passwordController,
          isValid: newAccount.password!.length > 0,
          hint: 'Z6XEa3p-!+',
          obscureText: !isPasswordShown,
          controller: controller,
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordShown = !isPasswordShown;
              });
            },
            child: passwordIcon,
          ),
          bottom: GestureDetector(
            onTap: () {
              controller.clear();
              String generatedPassword = PasswordGenerator.generate();
              controller.text = generatedPassword;
              passwordController(generatedPassword);
              setState(() {
                isPasswordShown = true;
              });
            },
            child: Text(
              'Generate Strong Password',
              style: TextStyle(
                color: Palette.primaryDark,
                fontSize: Font.h5,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
      bottom: FAB(icon: FontAwesome5.check, onPress: done),
    );
  }
}
