import 'package:doggo_frontend/UserProfile/dogs_list.dart';
import 'package:doggo_frontend/UserProfile/edit_dog_data_page.dart';
import 'package:doggo_frontend/UserProfile/edit_user_profile_page.dart';
import 'package:doggo_frontend/UserProfile/user_profile.dart';
import 'package:doggo_frontend/registration_page.dart';
import 'package:doggo_frontend/set_dog_data_page.dart';
import 'package:doggo_frontend/set_user_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dogGO!',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.orangeAccent),
        brightness: Brightness.light
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/userprofile': (context) => UserProfileView(),
        '/dogsinfo': (context) => DogsList(),
        '/adduserdata': (context) => SetUserDataPage(),
        '/adddogdata': (context) => SetDogDataPage(),
        '/edituserdata': (context) => EditUserData(),
        '/editdogdata': (context) => EditDogData(),
      },
    );
  }
}