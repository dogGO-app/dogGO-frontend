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
        dogs: List<Dog>.from(json['dogs']),
        status: json['status']);
  }
}

enum DogLoverStatus { FOLLOWED, BLOCKED }
