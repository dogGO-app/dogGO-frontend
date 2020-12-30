
import 'package:doggo_frontend/Location/http/location.dart';

class Walk {
  String walkId;
  DateTime walkDateTime;
  List<String> dogsNames;
  LocationMarker marker;

  Walk({this.walkId, this.walkDateTime, this.dogsNames, this.marker});

  factory Walk.fromJson(Map<String, dynamic> json){
    return Walk(
      walkId: json['id'],
      walkDateTime: DateTime.parse(json['createdAt']),
      dogsNames: json['dogNames'].cast<String>(),
      marker: LocationMarker.fromJson(json['mapMarker'])
    );
  }
}