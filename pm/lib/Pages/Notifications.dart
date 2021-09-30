import 'package:flutter/material.dart';
import 'package:pm/Services/services.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  static final String id = 'Notifications';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late CurrentUser user;
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

  beforePicking() async {
    turnLoadingOn();
    if (user.notificationFreq == -1) {
      await user.getNotificaionFreq();
    }
    turnLoadingOff();
  }

  int getNotificationFreq() {
    return user.notificationFreq;
  }

  void pick(int id, int option) async {
    turnLoadingOn();
    bool success = await user.changeNotificationFreq(option);
    if (success) {
      Toast.showDone(context);
    } else {
      Toast.showSomethingWentWrong(context);
    }
    turnLoadingOff();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(
      builder: (context, model, child) {
        return BaseScaffold(
          header: 'Notifications',
          subHeader:
              'We will notify you on to do several things to keep your privacy.',
          isLoading: isLoading,
          widgets: [
            Picker(
              id: 0,
              options: [
                'Two years',
                'One years',
                'Six months',
                'Three months',
                'One month',
                'Never',
              ],
              beforePicking: beforePicking,
              pick: pick,
              title: 'Notify you to change your passwords every:',
              hint: 'Change passwords notification',
              filled: true,
              pickedOption: user.notificationFreq,
              value: ' ',
              height: true,
            ),
          ],
        );
      },
    );
  }
}
