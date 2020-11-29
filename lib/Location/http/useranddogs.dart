import 'package:doggo_frontend/Location/http/simpledog.dart';

class UserAndDogsInLocation{
  String userId;
  String nickname;
  String name;
  int likesCount;
  List<SimpleDog> dogs;

  UserAndDogsInLocation({this.userId, this.nickname, this.name,
    this.likesCount, this.dogs});

  factory UserAndDogsInLocation.fromJson(Map<String, dynamic> json){

    var doggoslist = json['dogs'] as List;
    List<SimpleDog> dogsList =
      doggoslist.map((d) => SimpleDog.fromJson(d)).toList();

    return UserAndDogsInLocation(
      userId: json["id"],
      nickname: json['nickname'],
      name: json["name"],
      likesCount: json['likesCount'],
      dogs: dogsList
    );
  }

}