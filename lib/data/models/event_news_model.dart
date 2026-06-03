// To parse this JSON data, do
//
//     final eventNewsModel = eventNewsModelFromJson(jsonString);

import 'dart:convert';

EventNewsModel eventNewsModelFromJson(String str) => EventNewsModel.fromJson(json.decode(str));

String eventNewsModelToJson(EventNewsModel data) => json.encode(data.toJson());

class EventNewsModel {
  Body? body;

  EventNewsModel({
    this.body,
  });

  factory EventNewsModel.fromJson(Map<String, dynamic> json) => EventNewsModel(
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body?.toJson(),
  };
}

class Body {
  int? page;
  int? totalPages;
  int? totalItems;
  int? limit;
  List<EventNewsData>? data;

  Body({
    this.page,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.data,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    page: json["page"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    limit: json["limit"],
    data: json["data"] == null ? [] : List<EventNewsData>.from(json["data"]!.map((x) => EventNewsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class EventNewsData {
  String? id;
  String? title;
  String? description;
  double? latitude;
  double? longitude;
  DateTime? eventTime;
  String? viewCounts;
  String? commentCounts;
  String? reactionCounts;
  String? reactionIcon;
  bool? hasReacted;
  bool? isAnimate;
  String? postType;
  String? distance;
  List<Attachment>? attachments;

  EventNewsData({
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.eventTime,
    this.viewCounts,
    this.commentCounts,
    this.reactionCounts,
    this.reactionIcon,
    this.postType,
    this.distance,
    this.hasReacted,
    this.attachments,
    this.isAnimate,
  });

  factory EventNewsData.fromJson(Map<String, dynamic> json) => EventNewsData(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    eventTime: json["eventTime"] == null ? null : DateTime.parse(json["eventTime"]),
    viewCounts: json["viewCounts"],
    commentCounts: json["commentCounts"],
    reactionCounts: json["reactionCounts"],
    isAnimate: json["isAnimate"],
    reactionIcon: json["reactionIcon"],
    postType: json["postType"],
    distance: json["distance"],
    hasReacted: json["hasReacted"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "eventTime": eventTime?.toIso8601String(),
    "viewCounts": viewCounts,
    "commentCounts": commentCounts,
    "reactionCounts": reactionCounts,
    "isAnimate": isAnimate,
    "reactionIcon": reactionIcon,
    "postType": postType,
    "distance": distance,
    "hasReacted": hasReacted,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
  };
  // Add copyWith method
  EventNewsData copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    DateTime? eventTime,
    String? viewCounts,
    String? commentCounts,
    String? reactionCounts,
    String? reactionIcon,
    String? postType,
    String? distance,
    bool? hasReacted,
    bool? isAnimate,
    List<Attachment>? attachments,
  }) {
    return EventNewsData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      eventTime: eventTime ?? this.eventTime,
      viewCounts: viewCounts ?? this.viewCounts,
      commentCounts: commentCounts ?? this.commentCounts,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionIcon: reactionIcon ?? this.reactionIcon,
      postType: postType ?? this.postType,
      distance: distance ?? this.distance,
      attachments: attachments ?? this.attachments,
      hasReacted: hasReacted ?? this.hasReacted,
      isAnimate: isAnimate ?? this.isAnimate,
    );
  }
}

class Attachment {
  String? attachment;
  bool? isSensitiveContent;
  bool? isShareAnonymously;
  dynamic userId;
  dynamic name;
  dynamic profilePicture;
  String? attachmentFileType;
  String? thumbnail;

  Attachment({
    this.attachment,
    this.isSensitiveContent,
    this.isShareAnonymously,
    this.userId,
    this.name,
    this.profilePicture,
    this.attachmentFileType,
    this.thumbnail,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    attachment: json["attachment"],
    isSensitiveContent: json["isSensitiveContent"],
    isShareAnonymously: json["isShareAnonymously"],
    userId: json["userId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    attachmentFileType: json["attachmentFileType"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "attachment": attachment,
    "isSensitiveContent": isSensitiveContent,
    "isShareAnonymously": isShareAnonymously,
    "userId": userId,
    "name": name,
    "profilePicture": profilePicture,
    "attachmentFileType": attachmentFileType,
    "thumbnail": thumbnail,
  };
}
