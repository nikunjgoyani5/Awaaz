// To parse this JSON data, do
//
//     final getSingleEventModel = getSingleEventModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

GetSingleEventModel getSingleEventModelFromJson(String str) => GetSingleEventModel.fromJson(json.decode(str));

String getSingleEventModelToJson(GetSingleEventModel data) => json.encode(data.toJson());

class GetSingleEventModel {
  String? message;
  GetSingleEventData? body;
  bool? status;

  GetSingleEventModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetSingleEventModel.fromJson(Map<String, dynamic> json) => GetSingleEventModel(
    message: json["message"],
    body: json["body"] == null ? null : GetSingleEventData.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class GetSingleEventData {
  String? id;
  num? longitude;
  num? latitude;
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
  String? reactionId;
  String? attachment;
  String? attachmentFileType;
  String? thumbnail;
  String? userId;
  String? name;
  String? profilePicture;
  List<EventTimeLine>? timeLines;
  String? postCategoryId;
  List<EventAttachment>? attachments;
  List<EventAttachmentWithTimeline>? attachmentWithTimeline;

  GetSingleEventData({
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
    this.thumbnail,
    this.userId,
    this.name,
    this.profilePicture,
    this.timeLines,
    this.postCategoryId,
    this.attachments,
    this.attachmentFileType,
    this.attachmentWithTimeline,
  });

  factory GetSingleEventData.fromJson(Map<String, dynamic> json) => GetSingleEventData(
    id: json["_id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
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
    thumbnail: json["thumbnail"],
    userId: json["userId"],
    name: json["name"],
    attachmentFileType: json["attachmentFileType"],
    profilePicture: json["profilePicture"],
    timeLines: json["timeLines"] == null ? [] : List<EventTimeLine>.from(json["timeLines"]!.map((x) => EventTimeLine.fromJson(x))),
    postCategoryId: json["postCategoryId"],
    attachments: json["attachments"] == null ? [] : List<EventAttachment>.from(json["attachments"]!.map((x) => EventAttachment.fromJson(x))),
    attachmentWithTimeline: json["attachmentWithTimeline"] == null ? [] : List<EventAttachmentWithTimeline>.from(json["attachmentWithTimeline"]!.map((x) => EventAttachmentWithTimeline.fromJson(x))),
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
    "attachmentFileType": attachmentFileType,
    "address": address,
    "postCategory": postCategory,
    "reactionIcon": reactionIcon,
    "reactionId": reactionId,
    "attachment": attachment,
    "thumbnail": thumbnail,
    "userId": userId,
    "name": name,
    "profilePicture": profilePicture,
    "timeLines": timeLines == null ? [] : List<dynamic>.from(timeLines!.map((x) => x.toJson())),
    "postCategoryId": postCategoryId,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "attachmentWithTimeline": attachmentWithTimeline == null ? [] : List<dynamic>.from(attachmentWithTimeline!.map((x) => x.toJson())),
  };
}

class EventAttachmentWithTimeline {
  String? eventTime;
  String? description;
  String? attachmentId;
  dynamic address;
  String? name;
  String? profilePicture;
  String? userId;
  String? type;
  String? attachment;
  String? attachmentFileType;
  TextEditingController? textEditingController;
  dynamic thumbnail;
  XFile? videoThumbnail;
  XFile? videoFile;
  Uint8List? videoBytes;
  bool? isHover;

  EventAttachmentWithTimeline({
    this.eventTime,
    this.description,
    this.attachmentId,
    this.textEditingController,
    this.address,
    this.name,
    this.profilePicture,
    this.userId,
    this.type,
    this.attachment,
    this.thumbnail,
    this.videoThumbnail,
    this.videoFile,
    this.videoBytes,
    this.attachmentFileType,
    this.isHover = false,
  });

  factory EventAttachmentWithTimeline.fromJson(Map<String, dynamic> json) => EventAttachmentWithTimeline(
    eventTime: json["eventTime"],
    description: json["description"],
    attachmentId: json["attachmentId"],
    address: json["address"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    userId: json["userId"],
    type: json["type"],
    attachment: json["attachment"],
    thumbnail: json["thumbnail"],
    attachmentFileType: json["attachmentFileType"],
  );

  Map<String, dynamic> toJson() => {
    "eventTime": eventTime,
    "description": description,
    "attachmentId": attachmentId,
    "address": address,
    "name": name,
    "profilePicture": profilePicture,
    "userId": userId,
    "type": type,
    "attachment": attachment,
    "thumbnail": thumbnail,
    "attachmentFileType": attachmentFileType,
  };
}

class EventAttachment {
  String? title;
  String? attachment;
  String? description;
  String? attachmentId;
  String? name;
  String? profilePicture;
  bool? isSensitiveContent;
  String? thumbnail;
  String? eventTime;

  EventAttachment({
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

  factory EventAttachment.fromJson(Map<String, dynamic> json) => EventAttachment(
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

class EventTimeLine {
  String? eventTime;
  String? description;
  String? attachmentId;
  dynamic address;
  dynamic countryCode;
  dynamic mobileNumber;
  String? id;

  EventTimeLine({
    this.eventTime,
    this.description,
    this.attachmentId,
    this.address,
    this.countryCode,
    this.mobileNumber,
    this.id,
  });

  factory EventTimeLine.fromJson(Map<String, dynamic> json) => EventTimeLine(
    eventTime: json["eventTime"],
    description: json["description"],
    attachmentId: json["attachmentId"],
    address: json["address"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "eventTime": eventTime,
    "description": description,
    "attachmentId": attachmentId,
    "address": address,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "_id": id,
  };
}
