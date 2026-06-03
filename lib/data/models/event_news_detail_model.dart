// To parse this JSON data, do
//
//     final eventNewsDetailModel = eventNewsDetailModelFromJson(jsonString);

import 'dart:convert';

EventNewsDetailModel eventNewsDetailModelFromJson(String str) =>
    EventNewsDetailModel.fromJson(json.decode(str));

String eventNewsDetailModelToJson(EventNewsDetailModel data) =>
    json.encode(data.toJson());

class EventNewsDetailModel {
  EventNewsDetailData? body;

  EventNewsDetailModel({
    this.body,
  });

  factory EventNewsDetailModel.fromJson(Map<String, dynamic> json) =>
      EventNewsDetailModel(
        body: json["body"] == null
            ? null
            : EventNewsDetailData.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
      };
}

class EventNewsDetailData {
  String? id;
  String? title;
  String? description;
  num? latitude;
  num? longitude;
  DateTime? eventTime;
  String? viewCounts;
  String? commentCounts;
  String? reactionCounts;
  bool? isPostSaved;
  bool? isNotificationOn;
  bool? hasReacted;
  String? sharedCount;
  String? notifiedUserCount;
  List<String>? hashTags;
  String? lostItemName;
  String? countryCode;
  String? mobileNumber;
  String? address;
  String? postCategory;
  String? postType;
  String? status;
  String? reactionIcon;
  String? distance;
  List<Attachment>? attachments;
  List<TimeLine>? timeLines;
  List<dynamic>? rescueUpdates;
  Category? mainCategory;
  Category? subCategory;

  EventNewsDetailData({
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.eventTime,
    this.viewCounts,
    this.isPostSaved,
    this.isNotificationOn,
    this.commentCounts,
    this.reactionCounts,
    this.sharedCount,
    this.notifiedUserCount,
    this.hashTags,
    this.lostItemName,
    this.countryCode,
    this.mobileNumber,
    this.address,
    this.postCategory,
    this.postType,
    this.reactionIcon,
    this.distance,
    this.attachments,
    this.timeLines,
    this.rescueUpdates,
    this.hasReacted,
    this.status,
    this.mainCategory,
    this.subCategory,
  });

  factory EventNewsDetailData.fromJson(Map<String, dynamic> json) =>
      EventNewsDetailData(
        id: json["_id"],
        title: json["title"],
        hasReacted: json["hasReacted"],
        description: json["description"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isPostSaved: json["isPostSaved"],
        isNotificationOn: json["isNotificationOn"],
        eventTime: json["eventTime"] == null
            ? null
            : DateTime.parse(json["eventTime"]),
        viewCounts: json["viewCounts"],
        commentCounts: json["commentCounts"],
        reactionCounts: json["reactionCounts"],
        sharedCount: json["sharedCount"],
        notifiedUserCount: json["notifiedUserCount"],
        hashTags: json["hashTags"] == null
            ? []
            : List<String>.from(json["hashTags"]!.map((x) => x)),
        lostItemName: json["lostItemName"],
        status: json["status"],
        countryCode: json["countryCode"],
        mobileNumber: json["mobileNumber"],
        address: json["address"],
        postCategory: json["postCategory"],
        postType: json["postType"],
        reactionIcon: json["reactionIcon"],
        distance: json["distance"],
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
        timeLines: json["timeLines"] == null
            ? []
            : List<TimeLine>.from(
                json["timeLines"]!.map((x) => TimeLine.fromJson(x))),
        rescueUpdates: json["rescueUpdates"] == null
            ? []
            : List<dynamic>.from(json["rescueUpdates"]!.map((x) => x)),
        mainCategory: json["mainCategory"] == null
            ? null
            : Category.fromJson(json["mainCategory"]),
        subCategory: json["subCategory"] == null
            ? null
            : Category.fromJson(json["subCategory"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "status": status,
        "hasReacted": hasReacted,
        "latitude": latitude,
        "longitude": longitude,
        "eventTime": eventTime?.toIso8601String(),
        "viewCounts": viewCounts,
        "commentCounts": commentCounts,
        "isPostSaved": isPostSaved,
        "isNotificationOn": isNotificationOn,
        "reactionCounts": reactionCounts,
        "sharedCount": sharedCount,
        "notifiedUserCount": notifiedUserCount,
        "hashTags":
            hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
        "lostItemName": lostItemName,
        "countryCode": countryCode,
        "mobileNumber": mobileNumber,
        "address": address,
        "postCategory": postCategory,
        "postType": postType,
        "reactionIcon": reactionIcon,
        "distance": distance,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "timeLines": timeLines == null
            ? []
            : List<dynamic>.from(timeLines!.map((x) => x.toJson())),
        "rescueUpdates": rescueUpdates == null
            ? []
            : List<dynamic>.from(rescueUpdates!.map((x) => x)),
        "mainCategory": mainCategory?.toJson(),
        "subCategory": subCategory?.toJson(),
      };
}

class Attachment {
  String? userId;
  DateTime? eventTime;
  String? type;
  String? title;
  String? attachment;
  String? thumbnailImage;
  String? attachmentFileType;
  String? description;
  String? attachmentId;
  String? name;
  dynamic profilePicture;
  bool? isSensitiveContent;

  Attachment({
    this.userId,
    this.eventTime,
    this.type,
    this.title,
    this.attachment,
    this.thumbnailImage,
    this.attachmentFileType,
    this.description,
    this.attachmentId,
    this.name,
    this.profilePicture,
    this.isSensitiveContent,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        userId: json["userId"],
        eventTime: json["eventTime"] == null
            ? null
            : DateTime.parse(json["eventTime"]),
        type: json["type"],
        title: json["title"],
        attachment: json["attachment"],
        thumbnailImage: json["thumbnail"],
        attachmentFileType: json["attachmentFileType"],
        description: json["description"],
        attachmentId: json["attachmentId"],
        name: json["name"],
        profilePicture: json["profilePicture"],
        isSensitiveContent: json["isSensitiveContent"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "eventTime": eventTime?.toIso8601String(),
        "type": type,
        "title": title,
        "attachment": attachment,
        "thumbnail": thumbnailImage,
        "attachmentFileType": attachmentFileType,
        "description": description,
        "attachmentId": attachmentId,
        "name": name,
        "profilePicture": profilePicture,
        "isSensitiveContent": isSensitiveContent,
      };
}

class TimeLine {
  DateTime? eventTime;
  String? description;
  String? attachmentId;
  String? address;
  String? countryCode;
  String? mobileNumber;
  String? id;

  TimeLine({
    this.eventTime,
    this.description,
    this.attachmentId,
    this.address,
    this.countryCode,
    this.mobileNumber,
    this.id,
  });

  factory TimeLine.fromJson(Map<String, dynamic> json) => TimeLine(
        eventTime: json["eventTime"] == null
            ? null
            : DateTime.parse(json["eventTime"]),
        description: json["description"],
        attachmentId: json["attachmentId"],
        address: json["address"],
        countryCode: json["countryCode"],
        mobileNumber: json["mobileNumber"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "eventTime": eventTime?.toIso8601String(),
        "description": description,
        "attachmentId": attachmentId,
        "address": address,
        "countryCode": countryCode,
        "mobileNumber": mobileNumber,
        "_id": id,
      };
}

class Category {
  String? id;
  String? eventName;
  String? eventIcon;

  Category({
    this.id,
    this.eventName,
    this.eventIcon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        eventName: json["eventName"],
        eventIcon: json["eventIcon"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "eventName": eventName,
        "eventIcon": eventIcon,
      };
}
