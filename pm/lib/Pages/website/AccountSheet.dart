import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountSheet extends StatefulWidget {
  final edit;
  final delete;
  final Account account;
  final isLoading;
  final confirmDeletion;

  AccountSheet({
    required this.edit,
    required this.delete,
    required this.account,
    required this.isLoading,
    required this.confirmDeletion,
  });

  @override
  _AccountSheetState createState() => _AccountSheetState();
}

class _AccountSheetState extends State<AccountSheet> {
  late CurrentUser user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    int _passwordRepeats = user.repeatedPassword(widget.account.password!);
    bool _weakPassword = user.isWeakPassword(widget.account.password!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SheetBar(),
              Text(
                'Press And Hold To Copy',
                style: TextStyle(
                  color: Palette.primaryDark,
                  fontSize: Font.h5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacers.h16,
              accountInfoWidget(),
              Spacers.h16,
              Spacers.h8,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Details:',
                  style: TextStyle(
                    color: Palette.primaryDark,
                    fontSize: Font.h3,
                  ),
                ),
              ),
              Spacers.h16,
              if (widget.account.isCompPassword == 1)
                detail('The password is compromised.'),
              detail('Password update: ${widget.account.date}.'),
              if (_passwordRepeats > 1)
                detail('The password is repeated $_passwordRepeats times.'),
              if (_weakPassword) detail('The password is weak.'),
            ],
          ),
          bottomWidget(),
        ],
      ),
    );
  }

  Widget detail(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        '• $text',
        style: TextStyle(
          color: Palette.primaryDark,
          fontSize: Font.h5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  accountInfoWidget() {
    return Column(
      children: [
        InfoContainer(
          title: 'Website',
          info: widget.account.website,
        ),
        Spacers.h16,
        InfoContainer(
          title: 'Email',
          info: widget.account.email,
        ),
        Spacers.h16,
        InfoContainer(
          title: 'Password',
          info: widget.account.password,
          isPassword: true,
        ),
      ],
    );
  }

  deleteAccountButton() {
    return GestureDetector(
      onDoubleTap: () => widget.confirmDeletion(widget.account.id),
      child: FAB(
        icon: FontAwesome5.trash,
        onPress: () => widget.delete(),
      ),
    );
  }

  editAccountButton() {
    return FAB(
      icon: FontAwesome5.tools,
      onPress: () => widget.edit(widget.account.id),
    );
  }

  loadingWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Loading(),
    );
  }

  optionsWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          deleteAccountButton(),
          const SizedBox(width: 100.0),
          editAccountButton(),
        ],
      ),
    );
  }

  bottomWidget() {
    if (widget.isLoading)
      return loadingWidget();
    else
      return optionsWidget();
  }
}
