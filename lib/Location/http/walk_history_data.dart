
import 'package:doggo_frontend/Dog/http/dog_data.dart';
import 'package:doggo_frontend/Location/http/location.dart';

class Walk {
  String walkId;
  DateTime walkDateTime;
  List<String> dogsNames;
  LocationMarker marker;

  Walk({this.walkId, this.walkDateTime, this.dogsNames, this.marker});

  factory Walk.fromJson(Map<String, dynamic> json){
    var doggoslist = json['dogs'] as List;
    List<String> dogsList =
    doggoslist.map((d) => Dog.fromJsonInLocation(d).name).toList();
    return Walk(
      walkId: json['id'],
      walkDateTime: DateTime.parse(json['createdAt']),
      dogsNames: dogsList,
      marker: LocationMarker.fromJson(json['mapMarker'])
    );
  }
}