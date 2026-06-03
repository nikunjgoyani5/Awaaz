// To parse this JSON data, do
//
//     final generalCategoryModel = generalCategoryModelFromJson(jsonString);

import 'dart:convert';

GeneralCategoryModel generalCategoryModelFromJson(String str) =>
    GeneralCategoryModel.fromJson(json.decode(str));

String generalCategoryModelToJson(GeneralCategoryModel data) =>
    json.encode(data.toJson());

class GeneralCategoryModel {
  String? message;
  List<CategorysModel>? categorysModel;
  bool? status;

  GeneralCategoryModel({
    this.message,
    this.categorysModel,
    this.status,
  });

  factory GeneralCategoryModel.fromJson(Map<String, dynamic> json) =>
      GeneralCategoryModel(
        message: json["message"],
        categorysModel: json["body"] == null
            ? []
            : List<CategorysModel>.from(
                json["body"]!.map((x) => CategorysModel.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "categorysModel": categorysModel == null
            ? []
            : List<dynamic>.from(categorysModel!.map((x) => x.toJson())),
        "status": status,
      };
}

class CategorysModel {
  String? id;
  String? eventName;
  String? eventIcon;
  String? adminId;
  String? notificationCategotyName;
  String? postType;
  List<SubCategory>? subCategories;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategorysModel({
    this.id,
    this.eventName,
    this.eventIcon,
    this.adminId,
    this.notificationCategotyName,
    this.postType,
    this.subCategories,
    this.createdAt,
    this.updatedAt,
  });

  factory CategorysModel.fromJson(Map<String, dynamic> json) => CategorysModel(
        id: json["_id"],
        eventName: json["eventName"],
        eventIcon: json["eventIcon"],
        adminId: json["adminId"],
        notificationCategotyName: json["notificationCategotyName"],
        postType: json["postType"],
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
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
        "eventIcon": eventIcon,
        "adminId": adminId,
        "notificationCategotyName": notificationCategotyName,
        "postType": postType,
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class SubCategory {
  String? eventName;
  String? notificationCategotyName;
  String? eventIcon;
  String? id;

  SubCategory({
    this.eventName,
    this.notificationCategotyName,
    this.eventIcon,
    this.id,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        eventName: json["eventName"],
        notificationCategotyName: json["notificationCategotyName"],
        eventIcon: json["eventIcon"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "eventName": eventName,
        "notificationCategotyName": notificationCategotyName,
        "eventIcon": eventIcon,
        "_id": id,
      };
}
