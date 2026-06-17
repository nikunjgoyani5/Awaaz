// To parse this JSON data, do
//
//     final getEventDraftsModel = getEventDraftsModelFromJson(jsonString);

import 'dart:convert';

GetEventDraftsModel getEventDraftsModelFromJson(String str) => GetEventDraftsModel.fromJson(json.decode(str));

String getEventDraftsModelToJson(GetEventDraftsModel data) => json.encode(data.toJson());

class GetEventDraftsModel {
  String? message;
  List<EventDraftData>? body;
  bool? status;

  GetEventDraftsModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetEventDraftsModel.fromJson(Map<String, dynamic> json) => GetEventDraftsModel(
    message: json["message"],
    body: json["body"] == null ? [] : List<EventDraftData>.from(json["body"]!.map((x) => EventDraftData.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class EventDraftData {
  String? id;
  bool? isDirectAdminPost;
  double? longitude;
  double? latitude;
  String? title;
  String? description;
  dynamic lostItemName;
  String? address;
  List<String>? hashTags;
  dynamic mobileNumber;
  dynamic reactionId;
  String? eventTime;
  dynamic countryCode;
  String? postCategoryId;
  String? postType;
  bool? isSensitiveContent;
  bool? isShareAnonymously;
  String? attachment;
  String? userRequestedEventId;
  String? thumbnail;
  String? userId;
  String? name;
  String? profilePicture;
  String? attachmentFileType;
  String? subCategoryId;
  String? mainCategoryId;

  EventDraftData({
    this.id,
    this.isDirectAdminPost,
    this.longitude,
    this.latitude,
    this.title,
    this.description,
    this.lostItemName,
    this.address,
    this.hashTags,
    this.mobileNumber,
    this.reactionId,
    this.eventTime,
    this.countryCode,
    this.postCategoryId,
    this.postType,
    this.isSensitiveContent,
    this.isShareAnonymously,
    this.attachment,
    this.userRequestedEventId,
    this.thumbnail,
    this.userId,
    this.name,
    this.profilePicture,
    this.attachmentFileType,
    this.mainCategoryId,
    this.subCategoryId,
  });

  factory EventDraftData.fromJson(Map<String, dynamic> json) => EventDraftData(
    id: json["_id"],
    isDirectAdminPost: json["isDirectAdminPost"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
    title: json["title"],
    description: json["description"],
    lostItemName: json["lostItemName"],
    address: json["address"],
    subCategoryId: json["subCategoryId"],
    name: json["name"],
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),
    mobileNumber: json["mobileNumber"],
    reactionId: json["reactionId"],
    eventTime: json["eventTime"],
    countryCode: json["countryCode"],
    postCategoryId: json["postCategoryId"],
    mainCategoryId: json["mainCategoryId"],
    postType: json["postType"],
    isSensitiveContent: json["isSensitiveContent"],
    isShareAnonymously: json["isShareAnonymously"],
    attachment: json["attachment"],
    userRequestedEventId: json["userRequestedEventId"],
    thumbnail: json["thumbnail"],
    userId: json["userId"],
    profilePicture: json["profilePicture"],
    attachmentFileType: json["attachmentFileType"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isDirectAdminPost": isDirectAdminPost,
    "longitude": longitude,
    "subCategoryId": subCategoryId,
    "name": name,
    "latitude": latitude,
    "title": title,
    "mainCategoryId": mainCategoryId,
    "description": description,
    "lostItemName": lostItemName,
    "address": address,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
    "mobileNumber": mobileNumber,
    "reactionId": reactionId,
    "eventTime": eventTime,
    "countryCode": countryCode,
    "postCategoryId": postCategoryId,
    "postType": postType,
    "isSensitiveContent": isSensitiveContent,
    "isShareAnonymously": isShareAnonymously,
    "attachment": attachment,
    "userRequestedEventId": userRequestedEventId,
    "thumbnail": thumbnail,
    "userId": userId,
    "profilePicture": profilePicture,
    "attachmentFileType": attachmentFileType,
  };
}
