import 'package:flutter/material.dart';

class AppFlow {
  const AppFlow({
    @required this.page,
    @required this.title,
    @required this.iconData,
    @required this.navigatorKey,
  })  : assert(page != null),
        assert(iconData != null),
        assert(navigatorKey != null);

  final Widget page;
  final String title;
  final IconData iconData;
  final GlobalKey<NavigatorState> navigatorKey;
}
