class UserDetailsResponse {
  final String firstName;
  final String lastName;
  final int age;
  final String hobby;

  UserDetailsResponse({this.firstName, this.lastName, this.age, this.hobby});

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        hobby: json['hobby']);
  }
}
