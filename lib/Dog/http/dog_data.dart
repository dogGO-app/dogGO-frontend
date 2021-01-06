class Dog {
  String id;
  String name;
  String breed;
  String color;
  String description;
  DateTime vaccinationDate;
  String avatarChecksum;

  Dog(
      {this.id,
      this.name,
      this.breed,
      this.color,
      this.description,
      this.vaccinationDate,
      this.avatarChecksum});

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      color: json['color'],
      description: json['description'],
      vaccinationDate: DateTime.parse(json['lastVaccinationDate']),
      avatarChecksum: json['avatarChecksum']
    );
  }

  factory Dog.fromJsonInLocation(Map<String, dynamic> json) {
    return Dog(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
        color: json['color'],
        avatarChecksum: json['avatarChecksum']);
  }

  factory Dog.fromFollowedBlockedJson(Map<String, dynamic> json) {
    return Dog(
        name: json['name'],
        breed: json['breed'],
        color: json['color'],
        description: null,
        vaccinationDate: null,
        avatarChecksum: json['avatarChecksum']);
  }
}
