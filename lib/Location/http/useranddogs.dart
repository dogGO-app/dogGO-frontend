import 'package:doggo_frontend/Dog/http/dog_data.dart';

class UserAndDogsInLocation{
  String userId;
  String nickname;
  String name;
  int likesCount;
  List<Dog> dogs;

  UserAndDogsInLocation({this.userId, this.nickname, this.name,
    this.likesCount, this.dogs});

  factory UserAndDogsInLocation.fromJson(Map<String, dynamic> json){

    var doggoslist = json['dogs'] as List;
    List<Dog> dogsList =
      doggoslist.map((d) => Dog.fromJsonInLocation(d)).toList();

    return UserAndDogsInLocation(
      userId: json["id"],
      nickname: json['nickname'],
      name: json["name"],
      likesCount: json['likesCount'],
      dogs: dogsList
    );
  }

}