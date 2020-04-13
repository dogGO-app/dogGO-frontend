import 'package:doggo_frontend/calendar/calendar_page.dart';
import 'package:doggo_frontend/dog/dogs_list_page.dart';
import 'package:doggo_frontend/map/map_page.dart';
import 'package:doggo_frontend/user/user_profile_page.dart';
import 'package:flutter/material.dart';

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          UserProfilePage(),
          MapPage(),
          DogsListPage(),
          CalendarPage(),
        ],
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Your profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Dogs'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
