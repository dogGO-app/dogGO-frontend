import 'package:flutter/cupertino.dart';

class LocationMarker {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  LocationMarker(
      {@required this.id,
      @required this.name,
      this.description,
      @required this.latitude,
      @required this.longitude});

  factory LocationMarker.fromJson(Map<String, dynamic> json) {
    return LocationMarker(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }
}
