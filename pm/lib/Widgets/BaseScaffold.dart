import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pm/UI/ui.dart';
import 'package:pm/Widgets/widgets.dart';
import 'package:connectivity/connectivity.dart';

class BaseScaffold extends StatefulWidget {
  final String header;
  final Widget? bottom;
  final Widget? drawer;
  final bool isLoading;
  final bool withBottomSpace;
  final String? subHeader;
  final IconData appBarIcon;
  final List<Widget> widgets;
  final Function? appBarAction;

  BaseScaffold({
    required this.header,
    required this.widgets,
    this.appBarIcon = FontAwesome5.chevron_left,
    this.drawer,
    this.bottom,
    this.subHeader,
    this.appBarAction,
    this.isLoading = false,
    this.withBottomSpace = false,
  });

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> subscription;

  bool internetConnection = true;
  bool keyboardVisibility = false;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          keyboardVisibility = visible;
        });
      }
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        internetConnection = result != ConnectivityResult.none;
      });
    });
    checkConnectivity();
  }

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      internetConnection = connectivityResult != ConnectivityResult.none;
    });
  }

  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];
    slivers.addAll(
      [
        SliverAppBar(
          backgroundColor: Palette.primaryLight,
          brightness: Brightness.light,
          leadingWidth: 24.0,
          leading: GestureDetector(
            onTap: () {
              if (widget.appBarIcon == FontAwesome5.times) {
                SystemNavigator.pop();
              } else if (widget.drawer == null) {
                if (widget.appBarAction == null) {
                  Navigator.pop(context);
                } else {
                  widget.appBarAction!();
                }
              } else {
                drawerKey.currentState!.openDrawer();
              }
            },
            child: Icon(
              widget.appBarIcon,
              color: Palette.primaryDark,
            ),
          ),
        ),
        Header(
          header: widget.header,
          subHeader: widget.subHeader,
        ),
        SliverToBoxAdapter(child: Spacers.h32),
      ],
    );
    for (Widget widget in widget.widgets) {
      slivers.addAll(
        [
          SliverToBoxAdapter(
            child: widget,
          ),
          SliverToBoxAdapter(child: Spacers.h16),
        ],
      );
    }
    if (widget.withBottomSpace) {
      slivers.add(
        SliverToBoxAdapter(child: Spacers.customSpacer(100.0)),
      );
    }

    return SafeArea(
      child: !internetConnection
          ? NoInternet()
          : Scaffold(
              key: drawerKey,
              drawer: widget.drawer,
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                    child: CustomScrollView(
                      slivers: slivers,
                    ),
                  ),
                  getBottomWidget(),
                ],
              ),
            ),
    );
  }

  Widget getBottomWidget() {
    if (widget.isLoading) {
      return Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
        child: Loading(),
      );
    } else if (widget.bottom != null && !keyboardVisibility) {
      return Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
        child: widget.bottom,
      );
    } else {
      return const SizedBox();
    }
  }
}
