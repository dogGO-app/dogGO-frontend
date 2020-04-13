class AddUserResponse {
  final String token;
  final String type;

  AddUserResponse({
    this.token, this.type
});

  factory AddUserResponse.fromJson(Map<String, dynamic> json) {
    return AddUserResponse(
      token: json['token'],
      type: json['type']
    );
  }
}