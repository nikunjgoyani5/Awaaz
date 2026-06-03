// To parse this JSON data, do
//
//     final fetchSearchUserList = fetchSearchUserListFromJson(jsonString);

import 'dart:convert';

FetchSearchUserList fetchSearchUserListFromJson(String str) =>
    FetchSearchUserList.fromJson(json.decode(str));

String fetchSearchUserListToJson(FetchSearchUserList data) =>
    json.encode(data.toJson());

class FetchSearchUserList {
  String? message;
  List<SearchUserData>? body;
  bool? status;

  FetchSearchUserList({
    this.message,
    this.body,
    this.status,
  });

  factory FetchSearchUserList.fromJson(Map<String, dynamic> json) =>
      FetchSearchUserList(
        message: json["message"],
        body: json["body"] == null
            ? []
            : List<SearchUserData>.from(
                json["body"]!.map((x) => SearchUserData.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
        "status": status,
      };
}

class SearchUserData {
  String? id;
  String? email;
  String? name;
  String? profilePicture;
  String? username;

  SearchUserData({
    this.id,
    this.email,
    this.name,
    this.profilePicture,
    this.username,
  });

  factory SearchUserData.fromJson(Map<String, dynamic> json) => SearchUserData(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        profilePicture: json["profilePicture"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "profilePicture": profilePicture,
        "username": username,
      };
}
