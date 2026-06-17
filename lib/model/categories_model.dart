//
//
// import 'dart:convert';
//
// CategoriesModel categorysModelFromJson(String str) =>
//     CategoriesModel.fromJson(json.decode(str));
//
// String categorysModelToJson(CategoriesModel data) => json.encode(data.toJson());
//
// class CategoriesModel {
//   String? message;
//   List<Categorie>? body;
//   bool? status;
//
//   CategoriesModel({
//     this.message,
//     this.body,
//     this.status,
//   });
//
//   factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
//       CategoriesModel(
//         message: json["message"],
//         body: json["body"] == null
//             ? []
//             : List<Categorie>.from(
//                 json["body"]!.map((x) => Categorie.fromJson(x))),
//         status: json["status"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "body": body == null
//             ? []
//             : List<dynamic>.from(body!.map((x) => x.toJson())),
//         "status": status,
//       };
// }
//
// class Categorie {
//   String? id;
//   String? eventName;
//   String? notificationCategotyName;
//   String? eventIcon;
//   String? adminId;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   Categorie({
//     this.id,
//     this.eventName,
//     this.eventIcon,
//     this.adminId,
//     this.createdAt,
//     this.updatedAt,
//     this.notificationCategotyName,
//   });
//
//   factory Categorie.fromJson(Map<String, dynamic> json) => Categorie(
//         id: json["_id"],
//         eventName: json["eventName"],
//     notificationCategotyName: json["notificationCategotyName"],
//         eventIcon: json["eventIcon"],
//         adminId: json["adminId"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "eventName": eventName,
//         "notificationCategotyName": notificationCategotyName,
//         "eventIcon": eventIcon,
//         "adminId": adminId,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//       };
// }
// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  String? message;
  List<Categorie>? body;
  bool? status;

  CategoriesModel({
    this.message,
    this.body,
    this.status,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    message: json["message"],
    body: json["body"] == null ? [] : List<Categorie>.from(json["body"]!.map((x) => Categorie.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class Categorie {
  String? postType;
  String? id;
  String? eventName;
  String? eventIcon;
  String? adminId;
  String? notificationCategotyName;
  String? createdAt;
  String? updatedAt;
  List<SubCategory>? subCategories;

  Categorie({
    this.postType,
    this.id,
    this.eventName,
    this.eventIcon,
    this.adminId,
    this.notificationCategotyName,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) => Categorie(
    postType: json["postType"],
    id: json["_id"],
    eventName: json["eventName"],
    eventIcon: json["eventIcon"],
    adminId: json["adminId"],
    notificationCategotyName: json["notificationCategotyName"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    subCategories: json["subCategories"] == null ? [] : List<SubCategory>.from(json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "postType": postType,
    "_id": id,
    "eventName": eventName,
    "eventIcon": eventIcon,
    "adminId": adminId,
    "notificationCategotyName": notificationCategotyName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "subCategories": subCategories == null ? [] : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
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
