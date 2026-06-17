

import 'dart:convert';

GetAttachedVideoListModel getAttachedVideoListModelFromJson(String str) => GetAttachedVideoListModel.fromJson(json.decode(str));

String getAttachedVideoListModelToJson(GetAttachedVideoListModel data) => json.encode(data.toJson());

class GetAttachedVideoListModel {
  String? message;
  List<AllAttachedVideos>? body;
  bool? status;

  GetAttachedVideoListModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetAttachedVideoListModel.fromJson(Map<String, dynamic> json) => GetAttachedVideoListModel(
    message: json["message"],
    body: json["body"] == null ? [] : List<AllAttachedVideos>.from(json["body"]!.map((x) => AllAttachedVideos.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class AllAttachedVideos {
  String? attachment;
  String? thumbnail;
  String? attachmentId;

  AllAttachedVideos({
    this.attachment,
    this.thumbnail,
    this.attachmentId,
  });

  factory AllAttachedVideos.fromJson(Map<String, dynamic> json) => AllAttachedVideos(
    attachment: json["attachment"],
    thumbnail: json["thumbnail"],
    attachmentId: json["attachmentId"],
  );

  Map<String, dynamic> toJson() => {
    "attachment": attachment,
    "thumbnail": thumbnail,
    "attachmentId": attachmentId,
  };
}
