

import 'dart:convert';

AllAdminModel allAdminModelFromJson(String str) => AllAdminModel.fromJson(json.decode(str));

String allAdminModelToJson(AllAdminModel data) => json.encode(data.toJson());

class AllAdminModel {
  String? message;
  Body? body;
  bool? status;

  AllAdminModel({
    this.message,
    this.body,
    this.status,
  });

  factory AllAdminModel.fromJson(Map<String, dynamic> json) => AllAdminModel(
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
  List<AdminList>? data;

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
    data: json["data"] == null ? [] : List<AdminList>.from(json["data"]!.map((x) => AdminList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "limit": limit,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AdminList {
  String? id;
  String? email;
  String? name;
  String? password;
  dynamic otp;
  dynamic otpExpiresAt;
  bool? isVerified;
  String? role;
  String? provider;
  String? mobileNumber;
  dynamic profilePicture;
  String? countryCode;
  String? createdAt;
  String? updatedAt;
  String? ownerApproveStatus;

  AdminList({
    this.id,
    this.email,
    this.name,
    this.password,
    this.otp,
    this.otpExpiresAt,
    this.isVerified,
    this.role,
    this.provider,
    this.mobileNumber,
    this.profilePicture,
    this.countryCode,
    this.createdAt,
    this.updatedAt,
    this.ownerApproveStatus,
  });

  factory AdminList.fromJson(Map<String, dynamic> json) => AdminList(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    password: json["password"],
    otp: json["otp"],
    otpExpiresAt: json["otpExpiresAt"],
    isVerified: json["isVerified"],
    role: json["role"],
    provider: json["provider"],
    mobileNumber: json["mobileNumber"],
    profilePicture: json["profilePicture"],
    countryCode: json["countryCode"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    ownerApproveStatus: json["ownerApproveStatus"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "password": password,
    "otp": otp,
    "otpExpiresAt": otpExpiresAt,
    "isVerified": isVerified,
    "role": role,
    "provider": provider,
    "mobileNumber": mobileNumber,
    "profilePicture": profilePicture,
    "countryCode": countryCode,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "ownerApproveStatus": ownerApproveStatus,
  };
}
