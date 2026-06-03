// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String? message;
  List<Category>? body;
  bool? status;

  CategoryModel({
    this.message,
    this.body,
    this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(
        message: json["message"],
        body: json["body"] == null
            ? []
            : List<Category>.from(
            json["body"]!.map((x) => Category.fromJson(x))),
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

class Category {
  String? id;
  String? eventName;
  String? notificationCategoryName;
  String? eventIcon;
  String? adminId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.eventName,
    this.eventIcon,
    this.adminId,
    this.createdAt,
    this.updatedAt,
    this.notificationCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    eventName: json["eventName"],
    notificationCategoryName: json["notificationCategoryName"],
    eventIcon: json["eventIcon"],
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
    "eventName": eventName,
    "notificationCategoryName": notificationCategoryName,
    "eventIcon": eventIcon,
    "adminId": adminId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
