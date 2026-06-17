

import 'dart:convert';

GetAppUserProfileModel getAppUserProfileModelFromJson(String str) => GetAppUserProfileModel.fromJson(json.decode(str));

String getAppUserProfileModelToJson(GetAppUserProfileModel data) => json.encode(data.toJson());

class GetAppUserProfileModel {
  String? message;
  GetAppUserProfileData? body;
  bool? status;

  GetAppUserProfileModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetAppUserProfileModel.fromJson(Map<String, dynamic> json) => GetAppUserProfileModel(
    message: json["message"],
    body: json["body"] == null ? null : GetAppUserProfileData.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class GetAppUserProfileData {
  String? id;
  String? name;
  String? profilePicture;
  bool isBlocked;
  String? allBroadcastCounts;
  String? totalApprovedEventViews;
  String? verifiedEventCounts;
  List<AllBroadcast>? allBroadcasts;
  List<AllBroadcast>? verifiedEventPosts;

  GetAppUserProfileData({
    this.id,
    this.name,
    this.profilePicture,
    this.isBlocked= false,
    this.allBroadcastCounts,
    this.totalApprovedEventViews,
    this.verifiedEventCounts,
    this.allBroadcasts,
    this.verifiedEventPosts,
  });

  factory GetAppUserProfileData.fromJson(Map<String, dynamic> json) => GetAppUserProfileData(
    id: json["_id"],
    name: json["name"],
    isBlocked: json["isBlocked"],
    profilePicture: json["profilePicture"],
    allBroadcastCounts: json["allBroadcastCounts"],
    totalApprovedEventViews: json["totalApprovedEventViews"],
    verifiedEventCounts: json["verifiedEventCounts"],
    allBroadcasts: json["allBroadcasts"] == null ? [] : List<AllBroadcast>.from(json["allBroadcasts"]!.map((x) => AllBroadcast.fromJson(x))),
    verifiedEventPosts: json["verifiedEventPosts"] == null ? [] : List<AllBroadcast>.from(json["verifiedEventPosts"]!.map((x) => AllBroadcast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profilePicture": profilePicture,
    "allBroadcastCounts": allBroadcastCounts,
    "isBlocked": isBlocked,
    "totalApprovedEventViews": totalApprovedEventViews,
    "verifiedEventCounts": verifiedEventCounts,
    "allBroadcasts": allBroadcasts == null ? [] : List<dynamic>.from(allBroadcasts!.map((x) => x.toJson())),
    "verifiedEventPosts": verifiedEventPosts == null ? [] : List<dynamic>.from(verifiedEventPosts!.map((x) => x.toJson())),
  };
}

class AllBroadcast {
  String? id;
  String? attachment;
  String? status;
  String? thumbnail;

  AllBroadcast({
    this.id,
    this.attachment,
    this.status,
    this.thumbnail,
  });

  factory AllBroadcast.fromJson(Map<String, dynamic> json) => AllBroadcast(
    id: json["_id"],
    attachment: json["attachment"],
    status: json["status"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "attachment": attachment,
    "status": status,
    "thumbnail": thumbnail,
  };
}
