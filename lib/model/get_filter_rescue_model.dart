// To parse this JSON data, do
//
//     final getFilterRescueModel = getFilterRescueModelFromJson(jsonString);

import 'dart:convert';

GetFilterRescueModel getFilterRescueModelFromJson(String str) => GetFilterRescueModel.fromJson(json.decode(str));

String getFilterRescueModelToJson(GetFilterRescueModel data) => json.encode(data.toJson());

class GetFilterRescueModel {
  String? message;
  Body? body;
  bool? status;

  GetFilterRescueModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetFilterRescueModel.fromJson(Map<String, dynamic> json) => GetFilterRescueModel(
    message: json["message"],
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class Body {
  int? page;
  int? totalPages;
  int? totalItems;
  int? limit;
  int? approvedCount;
  int? rejectedCount;
  int? pendingCount;
  int? totalCounts;
  List<FilterRescue>? data;

  Body({
    this.page,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.approvedCount,
    this.rejectedCount,
    this.pendingCount,
    this.totalCounts,
    this.data,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    page: json["page"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    limit: json["limit"],
    approvedCount: json["approvedCount"],
    rejectedCount: json["rejectedCount"],
    pendingCount: json["pendingCount"],
    totalCounts: json["totalCounts"],
    data: json["data"] == null ? [] : List<FilterRescue>.from(json["data"]!.map((x) => FilterRescue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "approvedCount": approvedCount,
    "rejectedCount": rejectedCount,
    "pendingCount": pendingCount,
    "totalCounts": totalCounts,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FilterRescue {
  String? id;
  String? title;
  String? description;
  String? attachment;
  String? attachmentFileType;
  String? status;
  String? eventTime;
  String? address;
  String? userId;
  String? name;
  String? profilePicture;
  String? postCategoryId;
  String? thumbnail;
  double? latitude;
  double? longitude;
  List<String>? hashTags;
  bool? isShareAnonymously;
  String? verifiedEventCounts;
  String? lostItemName;
  String? countryCode;
  String? mobileNumber;

  FilterRescue({
    this.id,
    this.title,
    this.description,
    this.attachment,
    this.attachmentFileType,
    this.status,
    this.eventTime,
    this.address,
    this.userId,
    this.name,
    this.profilePicture,
    this.postCategoryId,
    this.thumbnail,
    this.latitude,
    this.longitude,
    this.hashTags,
    this.isShareAnonymously,
    this.verifiedEventCounts,
    this.lostItemName,
    this.countryCode,
    this.mobileNumber,
  });

  factory FilterRescue.fromJson(Map<String, dynamic> json) => FilterRescue(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    attachment: json["attachment"],
    attachmentFileType: json["attachmentFileType"],
    status: json["status"],
    eventTime: json["eventTime"],
    address: json["address"],
    userId: json["userId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    postCategoryId: json["postCategoryId"],
    thumbnail: json["thumbnail"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),
    isShareAnonymously: json["isShareAnonymously"]?? false,
    verifiedEventCounts: json["verifiedEventCounts"],
    lostItemName: json["lostItemName"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "attachment": attachment,
    "attachmentFileType": attachmentFileType,
    "status": status,
    "eventTime": eventTime,
    "address": address,
    "userId": userId,
    "name": name,
    "profilePicture": profilePicture,
    "postCategoryId": postCategoryId,
    "thumbnail": thumbnail,
    "latitude": latitude,
    "longitude": longitude,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
    "isShareAnonymously": isShareAnonymously,
    "verifiedEventCounts": verifiedEventCounts,
    "lostItemName": lostItemName,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
  };
}
