
import 'dart:convert';

GetFilterEventModel getFilterEventModelFromJson(String str) => GetFilterEventModel.fromJson(json.decode(str));

String getFilterEventModelToJson(GetFilterEventModel data) => json.encode(data.toJson());

class GetFilterEventModel {
  String? message;
  Body? body;
  bool? status;

  GetFilterEventModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetFilterEventModel.fromJson(Map<String, dynamic> json) => GetFilterEventModel(
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
  List<FilterEvents>? data;

  Body({
    this.page,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.data,
    this.approvedCount,
    this.pendingCount,
    this.totalCounts,
    this.rejectedCount,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    page: json["page"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    limit: json["limit"],
    approvedCount: json["approvedCount"],
    pendingCount: json["pendingCount"],
    totalCounts: json["totalCounts"],
    rejectedCount: json["rejectedCount"],
    data: json["data"] == null ? [] : List<FilterEvents>.from(json["data"]!.map((x) => FilterEvents.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "approvedCount": approvedCount,
    "pendingCount": pendingCount,
    "totalCounts": totalCounts,
    "rejectedCount": rejectedCount,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FilterEvents {
  String? id;
  String? title;
  String? description;
  String? verifiedEventCounts;
  String? attachment;
  String? attachmentFileType;
  String? thumbnail;
  String? status;
  num? latitude;
  num? longitude;
  String? eventTime;
  String? userId;
  String? name;
  String? address;
  String? postCategoryId;
  dynamic profilePicture;
  List<String>? hashTags;
  bool isShareAnonymously;

  FilterEvents({
    this.id,
    this.title,
    this.description,
    this.attachment,
    this.longitude,
    this.verifiedEventCounts,
    this.status,
    this.eventTime,
    this.thumbnail,
    this.attachmentFileType,
    this.userId,
    this.name,
    this.address,
    this.profilePicture,
    this.hashTags,
    this.latitude,
    this.postCategoryId,
    this.isShareAnonymously = false,
  });

  factory FilterEvents.fromJson(Map<String, dynamic> json) => FilterEvents(
    id: json["_id"],
    title: json["title"],
    verifiedEventCounts: json["verifiedEventCounts"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    attachmentFileType: json["attachmentFileType"],
    description: json["description"],
    isShareAnonymously: json["isShareAnonymously"]?? false,
    attachment: json["attachment"],
    thumbnail: json["thumbnail"],
    status: json["status"],
    eventTime: json["eventTime"],
    userId: json["userId"],
    name: json["name"],
    address: json["address"],
    postCategoryId: json["postCategoryId"],
    profilePicture: json["profilePicture"],
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "attachment": attachment,
    "thumbnail": thumbnail,
    "status": status,
    "eventTime": eventTime,
    "verifiedEventCounts": verifiedEventCounts,
    "postCategoryId": postCategoryId,
    "userId": userId,
    "isShareAnonymously": isShareAnonymously,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "attachmentFileType": attachmentFileType,

    "address": address,
    "profilePicture": profilePicture,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),

  };
}
