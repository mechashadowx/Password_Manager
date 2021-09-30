import 'package:flutter/material.dart';
import 'package:pm/Models/models.dart';
import 'package:pm/Pages/pages.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class Website extends StatefulWidget {
  final website;

  Website({
    required this.website,
  });

  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  late var user;
  var website = '';
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<CurrentUser>(context, listen: false);
    website = Formatter.websiteHeader(widget.website);
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

  operationSuccess() {
    Toast.showDone(context);
    Navigator.pop(context);
  }

  operationFaild() {
    Toast.showSomethingWentWrong(context);
  }

  confirmDeletion(int id) async {
    turnLoadingOn();
    var success = await user.deleteAccount(id);
    if (success)
      operationSuccess();
    else
      operationFaild();
    turnLoadingOff();
  }

  deleteAccount() {
    Toast.showDoubleTapToConfirm(context);
  }

  editAccount(int id) {
    Navigator.pop(context);
    Navigator.push(
      context,
      CustomTransitions.fadeIn(
        context,
        EditAccount(accountId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(
      builder: (context, user, child) {
        List<Account> accounts = user.getAccountsByWebsite(widget.website);
        int numberOfWarnings = user.numberOfWarningsInWebsite(widget.website);

        return BaseScaffold(
          header: website,
          subHeader: subHeaderBuilder(user.accounts.length, numberOfWarnings),
          widgets: List.generate(accounts.length, (i) {
            final account = accounts[i];

            return GestureDetector(
              onTap: () => openAccount(account),
              behavior: HitTestBehavior.translucent,
              child: AccountListTile(
                isWarning: account.isCompPassword == 1,
                emailName: account.email,
              ),
            );
          }),
        );
      },
    );
  }

  String subHeaderBuilder(int numberOfAccounts, int numberOfWarnings) {
    if (numberOfWarnings == 0) {
      return 'You don\'t have any warnings.';
    } else {
      final accountsCountText =
          Formatter.numberWithName('account', numberOfAccounts);
      final warningsCountText =
          Formatter.numberWithName('warning', numberOfWarnings);
      return 'You have $accountsCountText and $warningsCountText.';
    }
  }

  void openAccount(Account account) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AccountSheet(
          edit: editAccount,
          delete: deleteAccount,
          account: account,
          isLoading: isLoading,
          confirmDeletion: confirmDeletion,
        );
      },
    );
  }
}
