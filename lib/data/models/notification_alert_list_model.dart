// To parse this JSON data, do
//
//     final notificationAlertList = notificationAlertListFromJson(jsonString);

import 'dart:convert';

NotificationAlertList notificationAlertListFromJson(String str) => NotificationAlertList.fromJson(json.decode(str));

String notificationAlertListToJson(NotificationAlertList data) => json.encode(data.toJson());

class NotificationAlertList {
  NotificationAlertData? body;

  NotificationAlertList({
    this.body,
  });

  factory NotificationAlertList.fromJson(Map<String, dynamic> json) => NotificationAlertList(
    body: json["body"] == null ? null : NotificationAlertData.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body?.toJson(),
  };
}

class NotificationAlertData {
  int? page;
  int? totalPages;
  int? totalItems;
  int? limit;
  List<NotificationData>? notifications;

  NotificationAlertData({
    this.page,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.notifications,
  });

  factory NotificationAlertData.fromJson(Map<String, dynamic> json) => NotificationAlertData(
    page: json["page"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    limit: json["limit"],
    notifications: json["notifications"] == null ? [] : List<NotificationData>.from(json["notifications"]!.map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class NotificationData {
  String? id;
  String? eventId;
  String? title;
  String? description;
  String? distance;
  String? attachment;
  String? thumbnail;
  DateTime? notificationSendTime;

  NotificationData({
    this.id,
    this.eventId,
    this.title,
    this.description,
    this.distance,
    this.attachment,
    this.thumbnail,
    this.notificationSendTime,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["_id"],
    eventId: json["eventId"],
    title: json["title"],
    description: json["description"],
    distance: json["distance"],
    attachment: json["attachment"],
    thumbnail: json["thumbnail"],
    notificationSendTime: json["notificationSendTime"] == null ? null : DateTime.parse(json["notificationSendTime"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "eventId": eventId,
    "title": title,
    "description": description,
    "distance": distance,
    "attachment": attachment,
    "thumbnail": thumbnail,
    "notificationSendTime": notificationSendTime?.toIso8601String(),
  };
}
