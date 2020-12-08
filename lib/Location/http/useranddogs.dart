import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/FollowedBlocked/http/dog_lover_data.dart';
import 'package:flutter/foundation.dart';

class UserAndDogsInLocation {
  String userId;
  String nickname;
  String name;
  List<Dog> dogs;
  RelationStatus relationStatus;
  WalkStatus walkStatus;
  int likesCount;

  UserAndDogsInLocation(
      {this.userId,
      this.nickname,
      this.name,
      this.dogs,
      this.relationStatus,
      this.walkStatus,
      this.likesCount});

  factory UserAndDogsInLocation.fromJson(Map<String, dynamic> json) {
    var doggoslist = json['dogs'] as List;
    List<Dog> dogsList =
        doggoslist.map((d) => Dog.fromJsonInLocation(d)).toList();

    return UserAndDogsInLocation(
        userId: json["id"],
        nickname: json['nickname'],
        name: json["name"],
        dogs: dogsList,
        relationStatus: json['relationshipStatus'] == 'FOLLOWS'
            ? RelationStatus.FOLLOWED
            : RelationStatus.BLOCKED,
        walkStatus: WalkStatus.values
            .firstWhere((element) => describeEnum(element) == json['walkStatus']),
        likesCount: json['likesCount']);
  }
}

enum WalkStatus { ONGOING, ARRIVED_AT_DESTINATION, LEFT_DESTINATION, CANCELED }
