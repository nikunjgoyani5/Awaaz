import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? message;
  Body? body;

  UsersModel({
    this.message,
    this.body,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        message: json["message"],
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "body": body?.toJson(),
      };
}

class Body {
  String? token;
  User? user;

  Body({
    this.token,
    this.user,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? role;
  String? email;
  String? profilePicture;
  dynamic name;

  User({
    this.id,
    this.role,
    this.email,
    this.name,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        role: json["role"],
        email: json["email"],
        name: json["name"],
    profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "role": role,
        "email": email,
        "name": name,
        "profilePicture": profilePicture,
      };
}
