import 'package:flutter/material.dart';

class Event {
  DateTime eventDateTime;
  String description;
  String dogName;
  String eventId;

  Event({this.eventDateTime, this.description, this.dogName, this.eventId});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventDateTime: DateTime.parse(json['date'] + " " + json['time']),
      description: json['description'],
      dogName: json['dogName'],
      eventId: json['id']
    );
  }
}

enum EventType {
  PAST, FUTURE
}
