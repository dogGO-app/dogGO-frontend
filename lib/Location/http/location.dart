import 'package:flutter/material.dart';

class LocationMarker {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int distanceInMeters;

  const LocationMarker({
    @required this.id,
    @required this.name,
    this.description,
    this.distanceInMeters,
    @required this.latitude,
    @required this.longitude,
  })  : assert(id != null),
        assert(name != null),
        assert(latitude != null),
        assert(longitude != null);

  factory LocationMarker.fromJson(Map<String, dynamic> json) {
    return LocationMarker(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distanceInMeters: 0
    );
  }

  factory LocationMarker.fromJsonRecommendation(Map<String, dynamic> json){
    return LocationMarker(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distanceInMeters: json['distanceInMeters'],
    );
  }
}
