class User {
  final String firstName;
  final String lastName;
  final int age;
  final String hobby;
  final String nickname;

  User(
      {this.firstName, this.lastName, this.age, this.hobby, this.nickname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        hobby: json['hobby'],
        nickname: json['nickname']);
  }
}
