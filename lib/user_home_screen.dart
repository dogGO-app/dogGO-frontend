import 'package:doggo_frontend/Custom/app_flow.dart';
import 'package:doggo_frontend/Custom/bottom_navigation_tab.dart';
import 'package:doggo_frontend/Custom/material_bottom_navigation_scaffold.dart';
import 'package:doggo_frontend/Dog/dogs_list_page.dart';
import 'package:doggo_frontend/Map/MapPage.dart';
import 'package:doggo_frontend/User/user_profile.dart';
import 'package:flutter/material.dart';

import 'Calendar/events_list_page.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentlySelectedIndex = 0;

  final List<AppFlow> appFlows = [
    AppFlow(
      page: UserProfileView(),
      title: 'Your profile',
      iconData: Icons.person,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      page: MapPage(),
      title: 'Map',
      iconData: Icons.map,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      page: DogsListPage(),
      title: 'Your dogs',
      iconData: Icons.pets,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      page: EventListPage(),
      title: 'Calendar',
      iconData: Icons.calendar_today,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await appFlows[_currentlySelectedIndex]
          .navigatorKey
          .currentState
          .maybePop(),
      child: MaterialBottomNavigationScaffold(
        navigationBarItems: appFlows
            .map(
              (flow) => BottomNavigationTab(
                bottomNavigationBarItem: BottomNavigationBarItem(
                  icon: Icon(flow.iconData),
                  title: Text(flow.title),
                ),
                navigatorKey: flow.navigatorKey,
                initialPageBuilder: (context) => flow.page,
              ),
            )
            .toList(),
        onItemSelected: (newIndex) => setState(
          () {
            if (_currentlySelectedIndex != newIndex) {
              _currentlySelectedIndex = newIndex;
            } else {
              // If the user is re-selecting the tab, the common
              // behavior is to empty the stack.
              appFlows[_currentlySelectedIndex]
                  .navigatorKey
                  .currentState
                  .popUntil((route) => route.isFirst);
            }
          },
        ),
        selectedIndex: _currentlySelectedIndex,
      ),
    );
  }
}
