// To parse this JSON data, do
//
//     final selectedAreaEventPostModel = selectedAreaEventPostModelFromJson(jsonString);

import 'dart:convert';

SelectedAreaEventPostModel selectedAreaEventPostModelFromJson(String str) => SelectedAreaEventPostModel.fromJson(json.decode(str));

String selectedAreaEventPostModelToJson(SelectedAreaEventPostModel data) => json.encode(data.toJson());

class SelectedAreaEventPostModel {
  Body? body;

  SelectedAreaEventPostModel({
    this.body,
  });

  factory SelectedAreaEventPostModel.fromJson(Map<String, dynamic> json) => SelectedAreaEventPostModel(
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body?.toJson(),
  };
}

class Body {
  int? eventCounts;
  List<SelectedAreaEventPostData>? data;

  Body({
    this.eventCounts,
    this.data,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    eventCounts: json["eventCounts"],
    data: json["data"] == null ? [] : List<SelectedAreaEventPostData>.from(json["data"]!.map((x) => SelectedAreaEventPostData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "eventCounts": eventCounts,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SelectedAreaEventPostData {
  String? id;
  String? title;
  String? description;
  DateTime? eventTime;
  String? attachment;
  String? attachmentFileType;
  num? latitude;
  num? longitude;
  String? thumbnail;
  String? postCategory;
  String? postCategoryName;
  String? viewCounts;
  String? reactionCounts;
  String? distance;
  String? status;
  List<String>? hashTags;


  SelectedAreaEventPostData({
    this.id,
    this.title,
    this.description,
    this.eventTime,
    this.attachment,
    this.attachmentFileType,
    this.latitude,
    this.longitude,
    this.hashTags,
    this.thumbnail,
    this.postCategory,
    this.postCategoryName,
    this.viewCounts,
    this.reactionCounts,
    this.distance,
    this.status,
  });

  factory SelectedAreaEventPostData.fromJson(Map<String, dynamic> json) => SelectedAreaEventPostData(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    eventTime: json["eventTime"] == null ? null : DateTime.parse(json["eventTime"]),
    attachment: json["attachment"],
    attachmentFileType: json["attachmentFileType"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    thumbnail: json["thumbnail"],
    postCategory: json["postCategory"],
    postCategoryName: json["postCategoryName"],
    viewCounts: json["viewCounts"],
    reactionCounts: json["reactionCounts"],
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),
    distance: json["distance"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "eventTime": eventTime?.toIso8601String(),
    "attachment": attachment,
    "attachmentFileType": attachmentFileType,
    "latitude": latitude,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
    "longitude": longitude,
    "thumbnail": thumbnail,
    "postCategory": postCategory,
    "postCategoryName": postCategoryName,
    "viewCounts": viewCounts,
    "reactionCounts": reactionCounts,
    "distance": distance,
    "status": status,
  };
}
