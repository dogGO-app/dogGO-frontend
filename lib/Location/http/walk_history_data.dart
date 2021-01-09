
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
    List<Dog> dogsList =
    doggoslist.map((d) => Dog.fromJsonInLocation(d)).toList();
    List<String> _doggosnames = [];
    dogsList.forEach((element) {_doggosnames.add(element.name); });
    return Walk(
      walkId: json['id'],
      walkDateTime: DateTime.parse(json['createdAt']),
      dogsNames: _doggosnames,
      marker: LocationMarker.fromJson(json['mapMarker'])
    );
  }
}