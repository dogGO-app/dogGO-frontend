import 'package:doggo_frontend/UserProfile/dogs_list.dart';
import 'package:flutter/material.dart';
import 'package:doggo_frontend/UserProfile/user_profile.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/userprofile',
  routes: {
    '/userprofile': (context) => UserProfileView(),
    '/dogsinfo': (context) => DogsList(),
  },
));
