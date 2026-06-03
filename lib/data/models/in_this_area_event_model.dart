// To parse this JSON data, do
//
//     final inThisAreaEventModel = inThisAreaEventModelFromJson(jsonString);

import 'dart:convert';

import 'package:eagle_eye/data/models/selected_area_event_post_model.dart';

InThisAreaEventModel inThisAreaEventModelFromJson(String str) => InThisAreaEventModel.fromJson(json.decode(str));

String inThisAreaEventModelToJson(InThisAreaEventModel data) => json.encode(data.toJson());

class InThisAreaEventModel {
  List<SelectedAreaEventPostData>? body;

  InThisAreaEventModel({
    this.body,
  });

  factory InThisAreaEventModel.fromJson(Map<String, dynamic> json) => InThisAreaEventModel(
    body: json["body"] == null ? [] : List<SelectedAreaEventPostData>.from(json["body"]!.map((x) => SelectedAreaEventPostData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

