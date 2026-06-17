// To parse this JSON data, do
//
//     final updateProfileModel = updateProfileModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileModel updateProfileModelFromJson(String str) => UpdateProfileModel.fromJson(json.decode(str));

String updateProfileModelToJson(UpdateProfileModel data) => json.encode(data.toJson());

class UpdateProfileModel {
  String? message;
  AdminProfileData? body;
  bool? status;

  UpdateProfileModel({
    this.message,
    this.body,
    this.status,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) => UpdateProfileModel(
    message: json["message"],
    body: json["body"] == null ? null : AdminProfileData.fromJson(json["body"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body?.toJson(),
    "status": status,
  };
}

class AdminProfileData {
  String? id;
  String? email;
  String? name;
  String? profilePicture;
  String? mobileNumber;
  String? countryCode;

  AdminProfileData({
    this.id,
    this.email,
    this.name,
    this.profilePicture,
    this.mobileNumber,
    this.countryCode,
  });

  factory AdminProfileData.fromJson(Map<String, dynamic> json) => AdminProfileData(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    mobileNumber: json["mobileNumber"],
    countryCode: json["countryCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "profilePicture": profilePicture,
    "mobileNumber": mobileNumber,
    "countryCode": countryCode,
  };
}
