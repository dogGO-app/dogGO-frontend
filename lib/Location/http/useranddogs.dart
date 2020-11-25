import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:flutter/material.dart';

class UserAndDogsInLocation{
  int userId;
  String firstName;
  List<Dog> dogs;

  UserAndDogsInLocation({this.userId, this.firstName, this.dogs});

  factory UserAndDogsInLocation.fromJson(Map<String, dynamic> json){
    return UserAndDogsInLocation(
      userId: json["id"],
      firstName: json["name"],
      dogs: json["dogs"]
    );
  }

}