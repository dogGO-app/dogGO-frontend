import 'package:doggo_frontend/home_screen.dart';
import 'package:doggo_frontend/registration_page.dart';
import 'package:doggo_frontend/registration_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Dog/set_dog_data_page.dart';
import 'User/set_user_data_page.dart';
import 'login_page.dart';

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
        '/homescreen': (context) => HomeScreen(),
        '/adduserdata': (context) => SetUserDataPage(),
        '/adddogdata': (context) => SetDogDataPage(),
        '/verify': (context) => RegistrationVerifyPage(),
      },
    );
  }
}
