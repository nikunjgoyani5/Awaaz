import 'dart:convert';

GetSupportModel getSupportModelFromJson(String str) =>
    GetSupportModel.fromJson(json.decode(str));

String getSupportModelToJson(GetSupportModel data) =>
    json.encode(data.toJson());

class GetSupportModel {
  List<SupportData>? data;

  GetSupportModel({
    this.data,
  });

  factory GetSupportModel.fromJson(Map<String, dynamic> json) =>
      GetSupportModel(
        data: json['body'] == null
            ? []
            : List<SupportData>.from(
                json['body']!.map((x) => SupportData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'body': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SupportData {
  String? id;
  String? email;
  String? subject;
  String? description;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;
  List<String>? attachments;
  int? v;

  SupportData({
    this.id,
    this.email,
    this.subject,
    this.description,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    this.v,
  });

  factory SupportData.fromJson(Map<String, dynamic> json) => SupportData(
        id: json['_id'],
        email: json['email'],
        subject: json['subject'],
        description: json['description'],
        status: json['status'],
        userId: json['userId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        attachments: json["attachments"] == null
            ? []
            : List<String>.from(json["attachments"]!.map((x) => x)),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'subject': subject,
        'description': description,
        'status': status,
        'userId': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'attachments': attachments,
        '__v': v,
      };
}
