import 'package:doggo_frontend/Dog/dogs_list_page.dart';
import 'package:doggo_frontend/Map/MapPage.dart';
import 'package:doggo_frontend/User/user_profile.dart';
import 'package:doggo_frontend/app_flow.dart';
import 'package:flutter/material.dart';

import 'Calendar/events_list_page.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentBarIndex = 0;
  final navKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

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
    final currentFlow = appFlows[_currentBarIndex];

    return WillPopScope(
      onWillPop: () async =>
          !await currentFlow.navigatorKey.currentState.maybePop(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentBarIndex,
          children: appFlows.map(_buildIndexedPageFlow).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.orangeAccent,
          selectedItemColor: Colors.white,
          currentIndex: _currentBarIndex,
          items: appFlows
              .map(
                (flow) => BottomNavigationBarItem(
                  title: Text(flow.title),
                  icon: Icon(flow.iconData),
                ),
              )
              .toList(),
          onTap: (newIndex) => setState(
            () {
              if (_currentBarIndex != newIndex) {
                _currentBarIndex = newIndex;
              } else {
                // If the user is re-selecting the tab, the common
                // behavior is to empty the stack.
                navKeys[_currentBarIndex]
                    .currentState
                    .popUntil((route) => route.isFirst);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIndexedPageFlow(AppFlow appFlow) => Navigator(
        key: appFlow.navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => appFlow.page,
        ),
      );
}
