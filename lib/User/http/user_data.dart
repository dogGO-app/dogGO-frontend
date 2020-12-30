class User {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String hobby;
  final String nickname;
  final int likes;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.age,
      this.hobby,
      this.nickname,
      this.likes});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        hobby: json['hobby'],
        nickname: json['nickname'],
        likes: json['likesCount']);
  }

  factory User.fromFollowedBlockedJson(Map<String, dynamic> json) {
    return User(
        id: null,
        firstName: null,
        lastName: null,
        age: null,
        hobby: null,
        nickname: json['receiverDogLoverNickname'],
        likes: null);
  }

  factory User.fromJsonWalkVersion(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: null,
        lastName: null,
        age: null,
        hobby: null,
        nickname: null,
        likes: null);
  }
}
