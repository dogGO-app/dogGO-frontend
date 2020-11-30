
class SimpleDog {
  String id;
  String name;
  String breed;
  String color;

  SimpleDog({this.id, this.name, this.breed, this.color});

  factory SimpleDog.fromJson(Map<String, dynamic> parsedJson) {
    return SimpleDog(
      id: parsedJson['id'],
      name: parsedJson['name'],
      breed: parsedJson['breed'],
      color: parsedJson['color']
    );
  }
}