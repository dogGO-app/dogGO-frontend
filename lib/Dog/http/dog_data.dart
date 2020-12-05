class Dog {
  String name;
  String breed;
  String color;
  String description;
  DateTime vaccinationDate;

  Dog(
      {this.name,
      this.breed,
      this.color,
      this.description,
      this.vaccinationDate});

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      name: json['name'],
      breed: json['breed'],
      color: json['color'],
      description: json['description'],
      vaccinationDate: DateTime.parse(json['lastVaccinationDate']),
    );
  }

  factory Dog.fromFollowedBlockedJson(Map<String, dynamic> json) {
    return Dog(
        name: json['name'],
        breed: json['breed'],
        color: json['color'],
        description: null,
        vaccinationDate: null);
  }
}
