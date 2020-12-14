import 'package:doggo_frontend/Custom/app_flow.dart';
import 'package:doggo_frontend/Custom/bottom_navigation_tab.dart';
import 'package:doggo_frontend/Custom/material_bottom_navigation_scaffold.dart';
import 'package:doggo_frontend/Dog/dogs_list_page.dart';
import 'package:doggo_frontend/FollowedBlocked/followed_blocked_list_page.dart';
import 'package:doggo_frontend/User/user_profile_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'Ads/ad_manager.dart';
import 'Calendar/events_list_page.dart';
import 'Location/map_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentlySelectedIndex = 0;

  BannerAd _bannerAd;

  final List<AppFlow> appFlows = [
    AppFlow(
      page: UserProfilePage(),
      title: 'Profile',
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
      title: 'Dogs',
      iconData: Icons.pets,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      page: EventListPage(),
      title: 'Calendar',
      iconData: Icons.calendar_today,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      page: FollowedBlockedListPage(),
      title: 'Relations',
      iconData: Icons.person_add,
      navigatorKey: GlobalKey<NavigatorState>(),
    )
  ];

  void _initAdMob() async {
    await FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

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
                  label: flow.title,
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
