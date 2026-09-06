import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? endDrawer;
  final Widget? drawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool isUnKeyboard;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final bool useSafeArea;
  final bool showGredientColor;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const CustomScaffold(
      {this.appBar,
      this.scaffoldKey,
      this.body,
      this.endDrawer,
      this.drawer,
      this.floatingActionButtonLocation,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.backgroundColor,
      this.extendBody = false,
      this.isUnKeyboard = true,
      this.resizeToAvoidBottomInset = true,
      this.useSafeArea = true,
      this.showGredientColor = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      extendBody: extendBody,
      endDrawer: endDrawer,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: useSafeArea ? SafeArea(child: body!) : body,
      backgroundColor: backgroundColor,
    );
  }
}
