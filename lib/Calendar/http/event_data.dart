import 'package:flutter/material.dart';

class Event {
  DateTime eventDate;
  TimeOfDay eventTime;
  String description;
  String dogName;
  String eventId;

  Event({this.eventDate, this.eventTime, this.description, this.dogName, this.eventId});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventDate: DateTime.parse(json['date']),
      eventTime: TimeOfDay.fromDateTime(DateTime.parse(json['date'] + " " + json['time'])),
      description: json['description'],
      dogName: json['dogName'],
      eventId: json['id']
    );
  }
}
