// To parse this JSON data, do
//
//     final getAllReportedPost = getAllReportedPostFromJson(jsonString);

import 'dart:convert';

GetAllReportedPost getAllReportedPostFromJson(String str) => GetAllReportedPost.fromJson(json.decode(str));

String getAllReportedPostToJson(GetAllReportedPost data) => json.encode(data.toJson());

class GetAllReportedPost {
  String? message;
  List<ReportedPost>? body;
  bool? status;

  GetAllReportedPost({
    this.message,
    this.body,
    this.status,
  });

  factory GetAllReportedPost.fromJson(Map<String, dynamic> json) => GetAllReportedPost(
    message: json["message"],
    body: json["body"] == null ? [] : List<ReportedPost>.from(json["body"]!.map((x) => ReportedPost.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class ReportedPost {
  String? postId;
  String? postImage;
  String? thumbnail;
  bool isDeleted;
  int? reportedCounts;
  String? latestReportedReason;
  List<ReportOfPost>? reports;

  ReportedPost({
    this.postId,
    this.postImage,
    this.thumbnail,
    this.reportedCounts,
    this.latestReportedReason,
    this.reports,
    this.isDeleted= false,
  });

  factory ReportedPost.fromJson(Map<String, dynamic> json) => ReportedPost(
    postId: json["postId"],
    postImage: json["postImage"],
    isDeleted: json["isDeleted"],
    thumbnail: json["thumbnail"],
    reportedCounts: json["reportedCounts"],
    latestReportedReason: json["latestReportedReason"],
    reports: json["reports"] == null ? [] : List<ReportOfPost>.from(json["reports"]!.map((x) => ReportOfPost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "postImage": postImage,
    "isDeleted": isDeleted,
    "thumbnail": thumbnail,
    "reportedCounts": reportedCounts,
    "latestReportedReason": latestReportedReason,
    "reports": reports == null ? [] : List<dynamic>.from(reports!.map((x) => x.toJson())),
  };
}

class ReportOfPost {
  String? userId;
  String? name;
  String? profilePicture;
  String? reason;

  ReportOfPost({
    this.userId,
    this.name,
    this.profilePicture,
    this.reason,
  });

  factory ReportOfPost.fromJson(Map<String, dynamic> json) => ReportOfPost(
    userId: json["userId"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "profilePicture": profilePicture,
    "reason": reason,
  };
}
