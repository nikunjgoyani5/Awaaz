

import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

GetSingleRescueModel getSingleRescueModelFromJson(String str) => GetSingleRescueModel.fromJson(json.decode(str));

String getSingleRescueModelToJson(GetSingleRescueModel data) => json.encode(data.toJson());

class GetSingleRescueModel {
  String? message;
  GetSingleRescueData? body;
  bool? status;

  GetSingleRescueModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetSingleRescueModel.fromJson(Map<String, dynamic> json) => GetSingleRescueModel(
    message: json["message"],
    body: json["body"] == null ? null : GetSingleRescueData.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class GetSingleRescueData {
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
  String? lostItemName;
  String? countryCode;
  String? mobileNumber;
  String? address;
  String? postCategory;
  String? reactionIcon;
  dynamic reactionId;
  String? attachment;
  String? attachmentFileType;
  String? thumbnail;
  dynamic userId;
  dynamic profilePicture;
  String? name;
  String? status;
  List<RescueTimeLine>? timeLines;
  String? postCategoryId;
  List<RescueAttachment>? attachments;
  List<RescueAttachmentWithTimeline>? attachmentWithTimeline;

  GetSingleRescueData({
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
    this.profilePicture,
    this.timeLines,
    this.postCategoryId,
    this.attachments,
    this.status,
    this.attachmentWithTimeline,
  });

  factory GetSingleRescueData.fromJson(Map<String, dynamic> json) => GetSingleRescueData(
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
    status: json["status"],
    reactionId: json["reactionId"],
    attachment: json["attachment"],
    attachmentFileType: json["attachmentFileType"],
    thumbnail: json["thumbnail"],
    userId: json["userId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    timeLines: json["timeLines"] == null ? [] : List<RescueTimeLine>.from(json["timeLines"]!.map((x) => RescueTimeLine.fromJson(x))),
    postCategoryId: json["postCategoryId"],
    attachments: json["attachments"] == null ? [] : List<RescueAttachment>.from(json["attachments"]!.map((x) => RescueAttachment.fromJson(x))),
    attachmentWithTimeline: json["attachmentWithTimeline"] == null ? [] : List<RescueAttachmentWithTimeline>.from(json["attachmentWithTimeline"]!.map((x) => RescueAttachmentWithTimeline.fromJson(x))),
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
    "status": status,
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
    "profilePicture": profilePicture,
    "timeLines": timeLines == null ? [] : List<dynamic>.from(timeLines!.map((x) => x.toJson())),
    "postCategoryId": postCategoryId,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "attachmentWithTimeline": attachmentWithTimeline == null ? [] : List<dynamic>.from(attachmentWithTimeline!.map((x) => x.toJson())),
  };
}

class RescueAttachmentWithTimeline {
  String? eventTime;
  String? description;
  String? attachmentId;
  String? address;
  String? mobileNumber;
  String? countryCode;
  String? name;
  dynamic profilePicture;
  dynamic userId;
  String? type;
  String? attachment;
  String? thumbnail;
  String? attachmentFileType;
  XFile? videoThumbnail;
  XFile? videoFile;
  Uint8List? videoBytes;
  bool? isHover;


  RescueAttachmentWithTimeline({
    this.eventTime,
    this.description,
    this.attachmentId,
    this.address,
    this.name,
    this.profilePicture,
    this.userId,
    this.type,
    this.attachment,
    this.thumbnail,
    this.attachmentFileType,
    this.videoThumbnail,
    this.videoFile,
    this.videoBytes,
    this.mobileNumber,
    this.countryCode,

    this.isHover = false,
  });

  factory RescueAttachmentWithTimeline.fromJson(Map<String, dynamic> json) => RescueAttachmentWithTimeline(
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
    mobileNumber: json["mobileNumber"],
    countryCode: json["countryCode"],
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
    "mobileNumber": mobileNumber,
    "countryCode": countryCode,
    "attachmentFileType": attachmentFileType,
  };
}

class RescueAttachment {
  String? title;
  String? attachment;
  String? description;
  String? attachmentId;
  String? name;
  dynamic profilePicture;
  bool? isSensitiveContent;
  String? thumbnail;
  String? eventTime;

  RescueAttachment({
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

  factory RescueAttachment.fromJson(Map<String, dynamic> json) => RescueAttachment(
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

class RescueTimeLine {
  String? eventTime;
  String? description;
  String? attachmentId;
  String? address;
  dynamic countryCode;
  dynamic mobileNumber;
  String? id;

  RescueTimeLine({
    this.eventTime,
    this.description,
    this.attachmentId,
    this.address,
    this.countryCode,
    this.mobileNumber,
    this.id,
  });

  factory RescueTimeLine.fromJson(Map<String, dynamic> json) => RescueTimeLine(
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
