// To parse this JSON data, do
//
//     final getFilterGeneralModel = getFilterGeneralModelFromJson(jsonString);

import 'dart:convert';

GetFilterGeneralModel getFilterGeneralModelFromJson(String str) => GetFilterGeneralModel.fromJson(json.decode(str));

String getFilterGeneralModelToJson(GetFilterGeneralModel data) => json.encode(data.toJson());

class GetFilterGeneralModel {
  String? message;
  Body? body;
  bool? status;

  GetFilterGeneralModel({
    this.message,
    this.body,
    this.status,
  });

  factory GetFilterGeneralModel.fromJson(Map<String, dynamic> json) => GetFilterGeneralModel(
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
  int? approvedCount;
  int? rejectedCount;
  int? pendingCount;
  int? totalCounts;
  List<FilterGeneral>? data;

  Body({
    this.page,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.approvedCount,
    this.rejectedCount,
    this.pendingCount,
    this.totalCounts,
    this.data,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    page: json["page"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    limit: json["limit"],
    approvedCount: json["approvedCount"],
    rejectedCount: json["rejectedCount"],
    pendingCount: json["pendingCount"],
    totalCounts: json["totalCounts"],
    data: json["data"] == null ? [] : List<FilterGeneral>.from(json["data"]!.map((x) => FilterGeneral.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "approvedCount": approvedCount,
    "rejectedCount": rejectedCount,
    "pendingCount": pendingCount,
    "totalCounts": totalCounts,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FilterGeneral {
  String? id;
  String? title;
  String? description;
  String? attachment;
  String? attachmentFileType;
  String? status;
  String? eventTime;
  String? address;
  dynamic userId;
  dynamic name;
  dynamic profilePicture;
  dynamic username;
  dynamic postCategoryId;
  String? mainCategoryId;
  String? subCategoryId;
  Category? postCategory;
  Category? mainCategory;
  Category? subCategory;
  String? thumbnail;
  double? latitude;
  double? longitude;
  List<String>? hashTags;
  bool? isShareAnonymously;
  String? verifiedEventCounts;
  dynamic lostItemName;
  dynamic countryCode;
  dynamic mobileNumber;
  String? currentStatus;

  FilterGeneral({
    this.id,
    this.title,
    this.description,
    this.attachment,
    this.attachmentFileType,
    this.status,
    this.eventTime,
    this.address,
    this.userId,
    this.name,
    this.profilePicture,
    this.username,
    this.postCategoryId,
    this.mainCategoryId,
    this.subCategoryId,
    this.postCategory,
    this.mainCategory,
    this.subCategory,
    this.thumbnail,
    this.latitude,
    this.longitude,
    this.hashTags,
    this.isShareAnonymously,
    this.verifiedEventCounts,
    this.lostItemName,
    this.countryCode,
    this.mobileNumber,
    this.currentStatus,
  });

  factory FilterGeneral.fromJson(Map<String, dynamic> json) => FilterGeneral(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    attachment: json["attachment"],
    attachmentFileType: json["attachmentFileType"],
    status: json["status"],
    eventTime: json["eventTime"],
    address: json["address"],
    userId: json["userId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    username: json["username"],
    postCategoryId: json["postCategoryId"],
    mainCategoryId: json["mainCategoryId"],
    subCategoryId: json["subCategoryId"],
    postCategory: json["postCategory"] == null ? null : Category.fromJson(json["postCategory"]),
    mainCategory: json["mainCategory"] == null ? null : Category.fromJson(json["mainCategory"]),
    subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
    thumbnail: json["thumbnail"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    hashTags: json["hashTags"] == null ? [] : List<String>.from(json["hashTags"]!.map((x) => x)),
    isShareAnonymously: json["isShareAnonymously"]?? false,
    verifiedEventCounts: json["verifiedEventCounts"],
    lostItemName: json["lostItemName"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    currentStatus: json["currentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "attachment": attachment,
    "attachmentFileType": attachmentFileType,
    "status": status,
    "eventTime": eventTime,
    "address": address,
    "userId": userId,
    "name": name,
    "profilePicture": profilePicture,
    "username": username,
    "postCategoryId": postCategoryId,
    "mainCategoryId": mainCategoryId,
    "subCategoryId": subCategoryId,
    "postCategory": postCategory?.toJson(),
    "mainCategory": mainCategory?.toJson(),
    "subCategory": subCategory?.toJson(),
    "thumbnail": thumbnail,
    "latitude": latitude,
    "longitude": longitude,
    "hashTags": hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
    "isShareAnonymously": isShareAnonymously,
    "verifiedEventCounts": verifiedEventCounts,
    "lostItemName": lostItemName,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "currentStatus": currentStatus,
  };
}

class Category {
  String? eventName;
  String? notificationCategotyName;
  String? eventIcon;

  Category({
    this.eventName,
    this.notificationCategotyName,
    this.eventIcon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    eventName: json["eventName"],
    notificationCategotyName: json["notificationCategotyName"],
    eventIcon: json["eventIcon"],
  );

  Map<String, dynamic> toJson() => {
    "eventName": eventName,
    "notificationCategotyName": notificationCategotyName,
    "eventIcon": eventIcon,
  };
}
