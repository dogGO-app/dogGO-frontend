class User {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String hobby;
  final String nickname;
  final int likes;
  final String avatarChecksum;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.age,
      this.hobby,
      this.nickname,
      this.likes,
      this.avatarChecksum});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        hobby: json['hobby'],
        nickname: json['nickname'],
        likes: json['likesCount'],
        avatarChecksum: json['avatarChecksum']);
  }

  factory User.fromFollowedBlockedJson(Map<String, dynamic> json) {
    return User(
        id: json['receiverDogLoverId'],
        firstName: null,
        lastName: null,
        age: null,
        hobby: null,
        nickname: json['receiverDogLoverNickname'],
        likes: null,
        avatarChecksum: json['receiverDogLoverAvatarChecksum']);
  }

  factory User.fromJsonWalkVersion(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: null,
        lastName: null,
        age: null,
        hobby: null,
        nickname: null,
        likes: null,
        avatarChecksum: null);
  }
}
