

import 'dart:convert';

NotificationOnOffModel notificationOnOffModelFromJson(String str) => NotificationOnOffModel.fromJson(json.decode(str));

String notificationOnOffModelToJson(NotificationOnOffModel data) => json.encode(data.toJson());

class NotificationOnOffModel {
  String? message;
  Body? body;
  bool? status;

  NotificationOnOffModel({
    this.message,
    this.body,
    this.status,
  });

  factory NotificationOnOffModel.fromJson(Map<String, dynamic> json) => NotificationOnOffModel(
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
  bool? isNotificationOn;

  Body({
    this.isNotificationOn,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    isNotificationOn: json["isNotificationOn"],
  );

  Map<String, dynamic> toJson() => {
    "isNotificationOn": isNotificationOn,
  };
}
