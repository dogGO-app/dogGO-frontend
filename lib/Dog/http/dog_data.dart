class Dog {
  String id;
  String name;
  String breed;
  String color;
  String description;
  DateTime vaccinationDate;

  Dog(
      {this.id,
        this.name,
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

  factory Dog.fromJsonInLocation(Map<String, dynamic> json){
    return Dog(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      color: json['color']
    );
  }
}
