// To parse this JSON data, do
//
//     final otherUserProfileModel = otherUserProfileModelFromJson(jsonString);

import 'dart:convert';

OtherUserProfileModel otherUserProfileModelFromJson(String str) =>
    OtherUserProfileModel.fromJson(json.decode(str));

String otherUserProfileModelToJson(OtherUserProfileModel data) =>
    json.encode(data.toJson());

class OtherUserProfileModel {
  OtherUserProfileData? body;

  OtherUserProfileModel({
    this.body,
  });

  factory OtherUserProfileModel.fromJson(Map<String, dynamic> json) =>
      OtherUserProfileModel(
        body: json["body"] == null
            ? null
            : OtherUserProfileData.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
      };
}

class OtherUserProfileData {
  String? id;
  String? name;
  String? username;
  dynamic profilePicture;
  bool? isBlocked;
  String? allBroadcastCounts;
  String? totalApprovedEventViews;
  String? verifiedEventCounts;
  List<AllBroadcast>? allBroadcasts;
  List<AllBroadcast>? verifiedEventPosts;

  OtherUserProfileData({
    this.id,
    this.name,
    this.username,
    this.profilePicture,
    this.allBroadcastCounts,
    this.totalApprovedEventViews,
    this.isBlocked,
    this.verifiedEventCounts,
    this.allBroadcasts,
    this.verifiedEventPosts,
  });

  factory OtherUserProfileData.fromJson(Map<String, dynamic> json) =>
      OtherUserProfileData(
        id: json["_id"],
        name: json["name"],
        username: json["username"],
        profilePicture: json["profilePicture"],
        allBroadcastCounts: json["allBroadcastCounts"],
        isBlocked: json['isBlocked'],
        totalApprovedEventViews: json["totalApprovedEventViews"],
        verifiedEventCounts: json["verifiedEventCounts"],
        allBroadcasts: json["allBroadcasts"] == null
            ? []
            : List<AllBroadcast>.from(
                json["allBroadcasts"]!.map((x) => AllBroadcast.fromJson(x))),
        verifiedEventPosts: json["verifiedEventPosts"] == null
            ? []
            : List<AllBroadcast>.from(json["verifiedEventPosts"]!
                .map((x) => AllBroadcast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "username": username,
        "isBlocked": isBlocked,
        "profilePicture": profilePicture,
        "allBroadcastCounts": allBroadcastCounts,
        "totalApprovedEventViews": totalApprovedEventViews,
        "verifiedEventCounts": verifiedEventCounts,
        "allBroadcasts": allBroadcasts == null
            ? []
            : List<dynamic>.from(allBroadcasts!.map((x) => x.toJson())),
        "verifiedEventPosts": verifiedEventPosts == null
            ? []
            : List<dynamic>.from(verifiedEventPosts!.map((x) => x.toJson())),
      };
}

class AllBroadcast {
  String? id;
  String? attachment;
  String? thumbnail;
  String? status;
  String? adminCreatedPostId;
  String? eventPostViewCounts;
  bool? isSensitiveContent;
  String? postType;
  String? fileType;

  AllBroadcast({
    this.id,
    this.attachment,
    this.thumbnail,
    this.status,
    this.adminCreatedPostId,
    this.eventPostViewCounts,
    this.isSensitiveContent,
    this.postType,
    this.fileType,
  });

  factory AllBroadcast.fromJson(Map<String, dynamic> json) => AllBroadcast(
        id: json["_id"],
        attachment: json["attachment"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        adminCreatedPostId: json["adminCreatedPostId"],
        isSensitiveContent: json["isSensitiveContent"],
        postType: json['postType'],
        fileType: json['fileType'],
        eventPostViewCounts:
            json['eventPostViewCounts'] ?? json['attachmentViewCounts'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "attachment": attachment,
        "thumbnail": thumbnail,
        "status": status,
        "adminCreatedPostId": adminCreatedPostId,
        "isSensitiveContent": isSensitiveContent,
        "eventPostViewCounts": eventPostViewCounts,
      };
}
