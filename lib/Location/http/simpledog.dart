
class SimpleDog {
  String id;
  String name;
  String breed;

  SimpleDog({this.id, this.name, this.breed});

  factory SimpleDog.fromJson(Map<String, dynamic> parsedJson) {
    return SimpleDog(
      id: parsedJson['id'],
      name: parsedJson['name'],
      breed: parsedJson['breed']
    );
  }
}