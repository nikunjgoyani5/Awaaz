// To parse this JSON data, do
//
//     final getSingleGeneralModel = getSingleGeneralModelFromJson(jsonString);

import 'dart:convert';

GetSingleGeneralModel getSingleGeneralModelFromJson(String str) => GetSingleGeneralModel.fromJson(json.decode(str));

String getSingleGeneralModelToJson(GetSingleGeneralModel data) => json.encode(data.toJson());

class GetSingleGeneralModel {
  String? message;
  GetSingleGeneralData? body;
  bool? status;

  GetSingleGeneralModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetSingleGeneralModel.fromJson(Map<String, dynamic> json) => GetSingleGeneralModel(
    message: json["message"],
    body: json["body"] == null ? null : GetSingleGeneralData.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class GetSingleGeneralData {
  String? id;
  double? longitude;
  double? latitude;
  String? title;
  String? description;
  String? eventTime;
  int? viewCounts;
  int? commentCounts;
  int? reactionCounts;
  List<String>? hashTags;
  int? sharedCount;
  int? notifiedUserCount;
  dynamic lostItemName;
  dynamic countryCode;
  dynamic mobileNumber;
  String? address;
  String? postCategory;
  String? reactionIcon;
  dynamic reactionId;
  String? attachment;
  String? attachmentFileType;
  String? thumbnail;
  String? userId;
  String? name;
  String? status;
  String? profilePicture;
  List<dynamic>? timeLines;
  dynamic postCategoryId;
  String? mainCategoryId;
  String? subCategoryId;
  List<Attachment>? attachments;
  List<dynamic>? attachmentWithTimeline;

  GetSingleGeneralData({
    this.id,
    this.longitude,
    this.latitude,
    this.title,
    this.description,
    this.eventTime,
    this.viewCounts,
    this.commentCounts,
    this.reactionCounts,
    this.hashTags,
    this.sharedCount,
    this.notifiedUserCount,
    this.lostItemName,
    this.countryCode,
    this.mobileNumber,
    this.address,
    this.postCategory,
    this.reactionIcon,
    this.reactionId,
    this.attachment,
    this.attachmentFileType,
    this.thumbnail,
    this.userId,
    this.name,
    this.status,
    this.profilePicture,
    this.timeLines,
    this.postCategoryId,
    this.mainCategoryId,
    this.subCategoryId,
    this.attachments,
    this.attachmentWithTimeline,
  });

  factory GetSingleGeneralData.fromJson(Map<String, dynamic> json) => GetSingleGeneralData(
    id: json["_id"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
    title: json["title"],
    description: json["description"],
    eventTime: json["eventTime"],
    viewCounts: json["viewCounts"],
    commentCounts: json["commentCounts"],
    reactionCounts: json["reactionCounts"],
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),
    sharedCount: json["sharedCount"],
    notifiedUserCount: json["notifiedUserCount"],
    lostItemName: json["lostItemName"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    address: json["address"],
    postCategory: json["postCategory"],
    reactionIcon: json["reactionIcon"],
    reactionId: json["reactionId"],
    attachment: json["attachment"],
    attachmentFileType: json["attachmentFileType"],
    thumbnail: json["thumbnail"],
    userId: json["userId"],
    name: json["name"],
    status: json["status"],
    profilePicture: json["profilePicture"],
    timeLines: json["timeLines"] == null ? [] : List<dynamic>.from(json["timeLines"]!.map((x) => x)),
    postCategoryId: json["postCategoryId"],
    mainCategoryId: json["mainCategoryId"],
    subCategoryId: json["subCategoryId"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    attachmentWithTimeline: json["attachmentWithTimeline"] == null ? [] : List<dynamic>.from(json["attachmentWithTimeline"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "longitude": longitude,
    "latitude": latitude,
    "title": title,
    "description": description,
    "eventTime": eventTime,
    "viewCounts": viewCounts,
    "commentCounts": commentCounts,
    "reactionCounts": reactionCounts,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
    "sharedCount": sharedCount,
    "notifiedUserCount": notifiedUserCount,
    "lostItemName": lostItemName,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "address": address,
    "postCategory": postCategory,
    "reactionIcon": reactionIcon,
    "reactionId": reactionId,
    "attachment": attachment,
    "attachmentFileType": attachmentFileType,
    "thumbnail": thumbnail,
    "userId": userId,
    "name": name,
    "status": status,
    "profilePicture": profilePicture,
    "timeLines": timeLines == null ? [] : List<dynamic>.from(timeLines!.map((x) => x)),
    "postCategoryId": postCategoryId,
    "mainCategoryId": mainCategoryId,
    "subCategoryId": subCategoryId,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "attachmentWithTimeline": attachmentWithTimeline == null ? [] : List<dynamic>.from(attachmentWithTimeline!.map((x) => x)),
  };
}

class Attachment {
  String? title;
  String? attachment;
  String? description;
  String? attachmentId;
  String? name;
  String? profilePicture;
  bool? isSensitiveContent;
  String? thumbnail;
  String? eventTime;

  Attachment({
    this.title,
    this.attachment,
    this.description,
    this.attachmentId,
    this.name,
    this.profilePicture,
    this.isSensitiveContent,
    this.thumbnail,
    this.eventTime,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    title: json["title"],
    attachment: json["attachment"],
    description: json["description"],
    attachmentId: json["attachmentId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    isSensitiveContent: json["isSensitiveContent"],
    thumbnail: json["thumbnail"],
    eventTime: json["eventTime"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "attachment": attachment,
    "description": description,
    "attachmentId": attachmentId,
    "name": name,
    "profilePicture": profilePicture,
    "isSensitiveContent": isSensitiveContent,
    "thumbnail": thumbnail,
    "eventTime": eventTime,
  };
}
