


import 'dart:convert';

GetAllRescueUpdatesModel getAllRescueUpdatesModelFromJson(String str) => GetAllRescueUpdatesModel.fromJson(json.decode(str));

String getAllRescueUpdatesModelToJson(GetAllRescueUpdatesModel data) => json.encode(data.toJson());

class GetAllRescueUpdatesModel {
  String? message;
  List<RescueUpdateData>? body;
  bool? status;

  GetAllRescueUpdatesModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetAllRescueUpdatesModel.fromJson(Map<String, dynamic> json) => GetAllRescueUpdatesModel(
    message: json["message"],
    body: json["body"] == null ? [] : List<RescueUpdateData>.from(json["body"]!.map((x) => RescueUpdateData.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class RescueUpdateData {
  String? id;
  String? attachment;
  String? description;
  double? latitude;
  double? longitude;
  String? countryCode;
  String? eventTime;
  String? mobileNumber;
  String? name;
  String? profilePicture;
  String? thumbnail;
  String? userId;
  String? attachmentFileType;
  String? address;

  RescueUpdateData({
    this.id,
    this.attachment,
    this.description,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.eventTime,
    this.mobileNumber,
    this.name,
    this.profilePicture,
    this.userId,
    this.thumbnail,
    this.attachmentFileType,
    this.address,
  });

  factory RescueUpdateData.fromJson(Map<String, dynamic> json) => RescueUpdateData(
    id: json["_id"],
    attachment: json["attachment"],
    description: json["description"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    countryCode: json["countryCode"],
    eventTime: json["eventTime"],
    mobileNumber: json["mobileNumber"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    thumbnail: json["thumbnail"],
    attachmentFileType: json["attachmentFileType"],
    userId: json["userId"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "attachment": attachment,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "countryCode": countryCode,
    "eventTime": eventTime,
    "mobileNumber": mobileNumber,
    "name": name,
    "profilePicture": profilePicture,
    "userId": userId,
    "thumbnail": thumbnail,
    "address": address,
    "attachmentFileType": attachmentFileType,
  };
}
