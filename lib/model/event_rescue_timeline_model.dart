import 'package:flutter/material.dart';

class EventTimelineModel {
  final TextEditingController description;
  TimeOfDay? time = TimeOfDay.now();
  final String image;

  EventTimelineModel({
    required this.description,
    this.time,
    required this.image,
  });
}

class RescueTimelineModel {
  final TextEditingController location;
  final TextEditingController update;
  final TextEditingController mobileNumber;
  DateTime? dateTime = DateTime.now();
  final String image;

  RescueTimelineModel({
    required this.location,
    required this.update,
    required this.mobileNumber,
    this.dateTime,
    required this.image,
  });
}
