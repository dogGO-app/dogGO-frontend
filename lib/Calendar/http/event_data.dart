import 'package:flutter/material.dart';

class Event {
  DateTime eventDate;
  TimeOfDay eventTime;
  String description;
  String dogName;

  Event({this.eventDate, this.eventTime, this.description, this.dogName});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventDate: DateTime.parse(json['date']),
      eventTime: TimeOfDay.fromDateTime(DateTime.parse(json['time'])),
      description: json['description'],
      dogName: json['dogName'],
    );
  }
}
