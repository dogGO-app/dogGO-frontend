import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/User/http/user_data.dart';

class DogLover {
  final User user;
  final List<Dog> dogs;
  final DogLoverStatus status;

  DogLover({this.user, this.dogs, this.status});

  factory DogLover.fromJson(Map<String, dynamic> json) {
    return DogLover(
        user: User.fromJson(json['user']),
        dogs: (json['dogs'] as List).map((e) => Dog.fromFollowedBlockedJson(e)).toList(),
        status: json['status']);
  }

  factory DogLover.fromFollowedBlockedJson(Map<String, dynamic> json) {
    return DogLover(
        user: User.fromFollowedBlockedJson(json),
        dogs: (json['receiverDogLoverDogs'] as List).map((e) => Dog.fromFollowedBlockedJson(e)).toList(),
        status: json['relationshipStatus'] == 'FOLLOWS'
            ? DogLoverStatus.FOLLOWED
            : DogLoverStatus.BLOCKED);
  }
}

enum DogLoverStatus { FOLLOWED, BLOCKED }
