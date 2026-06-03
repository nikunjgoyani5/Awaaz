// To parse this JSON data, do
//
//     final blockedUserModel = blockedUserModelFromJson(jsonString);

import 'dart:convert';

BlockedUserModel blockedUserModelFromJson(String str) => BlockedUserModel.fromJson(json.decode(str));

String blockedUserModelToJson(BlockedUserModel data) => json.encode(data.toJson());

class BlockedUserModel {
  List<BlockedUserData>? body;

  BlockedUserModel({
    this.body,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) => BlockedUserModel(
    body: json["body"] == null ? [] : List<BlockedUserData>.from(json["body"]!.map((x) => BlockedUserData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class BlockedUserData {
  String? id;
  String? email;
  String? name;
  String? profilePicture;

  BlockedUserData({
    this.id,
    this.email,
    this.name,
    this.profilePicture,
  });

  factory BlockedUserData.fromJson(Map<String, dynamic> json) => BlockedUserData(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "profilePicture": profilePicture,
  };
}
