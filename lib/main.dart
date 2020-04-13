import 'package:doggo_frontend/registration_page.dart';
import 'package:doggo_frontend/user_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dog/edit_dog_data_page.dart';
import 'dog/set_dog_data_page.dart';
import 'login_page.dart';
import 'user/edit_user_profile_page.dart';
import 'user/set_user_data_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dogGO!',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.orangeAccent),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/userroot': (context) => UserMainPage(),
        '/adduserdata': (context) => SetUserDataPage(),
        '/adddogdata': (context) => SetDogDataPage(),
        '/edituserdata': (context) => EditUserDataPage(),
        '/editdogdata': (context) => EditDogDataPage(),
      },
    );
  }
}
