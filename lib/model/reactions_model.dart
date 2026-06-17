// To parse this JSON data, do
//
//     final reactionsModel = reactionsModelFromJson(jsonString);

import 'dart:convert';

ReactionsModel reactionsModelFromJson(String str) =>
    ReactionsModel.fromJson(json.decode(str));

String reactionsModelToJson(ReactionsModel data) => json.encode(data.toJson());

class ReactionsModel {
  String? message;
  List<Reaction>? body;
  bool? status;

  ReactionsModel({
    this.message,
    this.body,
    this.status,

  });

  factory ReactionsModel.fromJson(Map<String, dynamic> json) => ReactionsModel(
        message: json["message"],
        body: json["body"] == null
            ? []
            : List<Reaction>.from(
                json["body"]!.map((x) => Reaction.fromJson(x))),
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

class Reaction {
  String? id;
  String? reactionName;
  String? reactionIcon;
  String? adminId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Reaction({
    this.id,
    this.reactionName,
    this.reactionIcon,
    this.adminId,
    this.createdAt,
    this.updatedAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        id: json["_id"],
        reactionName: json["reactionName"],
        reactionIcon: json["reactionIcon"],
        adminId: json["adminId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "reactionName": reactionName,
        "reactionIcon": reactionIcon,
        "adminId": adminId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
