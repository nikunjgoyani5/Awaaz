// To parse this JSON data, do
//
//     final logInModel = logInModelFromJson(jsonString);

import 'dart:convert';

import 'package:eagle_eye/data/models/user_model.dart';

AuthModel logInModelFromJson(String str) =>
    AuthModel.fromJson(json.decode(str));

String logInModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  Auth? body;

  AuthModel({
    this.body,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        body: json["body"] == null ? null : Auth.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
      };
}

class Auth {
  String? token;
  UserModel? user;

  Auth({
    this.token,
    this.user,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        token: json["token"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}
