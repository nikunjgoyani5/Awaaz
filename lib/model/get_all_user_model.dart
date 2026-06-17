// To parse this JSON data, do
//
//     final getAllUsers = getAllUsersFromJson(jsonString);

import 'dart:convert';

GetAllUsers getAllUsersFromJson(String str) => GetAllUsers.fromJson(json.decode(str));

String getAllUsersToJson(GetAllUsers data) => json.encode(data.toJson());

class GetAllUsers {
  String? message;
  Body? body;
  bool? status;

  GetAllUsers({
    this.message,
    this.body,
    this.status,
  });

  factory GetAllUsers.fromJson(Map<String, dynamic> json) => GetAllUsers(
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
  List<UserData>? data;

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
    data: json["data"] == null ? [] : List<UserData>.from(json["data"]!.map((x) => UserData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserData {
  String? id;
  String? name;
  String? profilePicture;
  bool? isBlocked;

  UserData({
    this.id,
    this.name,
    this.profilePicture,
    this.isBlocked,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["_id"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    isBlocked: json["isBlocked"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profilePicture": profilePicture,
    "isBlocked": isBlocked,
  };
}
