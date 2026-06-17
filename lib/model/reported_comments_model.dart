// To parse this JSON data, do
//
//     final getAllReportedComments = getAllReportedCommentsFromJson(jsonString);

import 'dart:convert';

GetAllReportedComments getAllReportedCommentsFromJson(String str) => GetAllReportedComments.fromJson(json.decode(str));

String getAllReportedCommentsToJson(GetAllReportedComments data) => json.encode(data.toJson());

class GetAllReportedComments {
  String? message;
  Body? body;
  bool? status;

  GetAllReportedComments({
    this.message,
    this.body,
    this.status,
  });

  factory GetAllReportedComments.fromJson(Map<String, dynamic> json) => GetAllReportedComments(
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
  int? totalPostCounts;
  List<ReportedComments>? data;

  Body({
    this.totalPostCounts,
    this.data,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    totalPostCounts: json["totalPostCounts"],
    data: json["data"] == null ? [] : List<ReportedComments>.from(json["data"]!.map((x) => ReportedComments.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPostCounts": totalPostCounts,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReportedComments {
  String? postId;
  String? postImage;
  String? thumbnail;
  int? totalReportedCount;
  String? firstReportedUserName;
  String? firstReportedUserImage;
  String? firstReportedReason;
  List<ReportOfComment>? reports;

  ReportedComments({
    this.postId,
    this.postImage,
    this.thumbnail,
    this.totalReportedCount,
    this.firstReportedUserName,
    this.firstReportedUserImage,
    this.firstReportedReason,
    this.reports,
  });

  factory ReportedComments.fromJson(Map<String, dynamic> json) => ReportedComments(
    postId: json["postId"],
    postImage: json["postImage"],
    thumbnail: json["thumbnail"],
    firstReportedReason: json["firstReportedReason"],
    totalReportedCount: json["totalReportedCount"],
    firstReportedUserName: json["firstReportedUserName"],
    firstReportedUserImage: json["firstReportedUserImage"],
    reports: json["reports"] == null ? [] : List<ReportOfComment>.from(json["reports"]!.map((x) => ReportOfComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "postImage": postImage,
    "thumbnail": thumbnail,
    "firstReportedReason": firstReportedReason,
    "totalReportedCount": totalReportedCount,
    "firstReportedUserName": firstReportedUserName,
    "firstReportedUserImage": firstReportedUserImage,
    "reports": reports == null ? [] : List<dynamic>.from(reports!.map((x) => x.toJson())),
  };
}

class ReportOfComment {
  String? commentId;
  dynamic commentReplyId;
  String? comment;
  String? timestamp;
  int? totalLikes;
  String? commentedUserId;
  String? commentedUserName;
  String? commentedUserImage;
  String? commentType;
  String? reportId;
  String? reason;
  int? reportCount;
  List<ReportedCommentUser>? reportedUsers;

  ReportOfComment({
    this.commentId,
    this.commentReplyId,
    this.comment,
    this.timestamp,
    this.totalLikes,
    this.commentedUserId,
    this.commentedUserName,
    this.commentedUserImage,
    this.commentType,
    this.reportId,
    this.reason,
    this.reportCount,
    this.reportedUsers
  });

  factory ReportOfComment.fromJson(Map<String, dynamic> json) => ReportOfComment(
    commentId: json["commentId"],
    commentReplyId: json["commentReplyId"],
    comment: json["comment"],
    timestamp: json["timestamp"],
    totalLikes: json["totalLikes"],
    commentedUserId: json["commentedUserId"],
    commentedUserName: json["commentedUserName"],
    commentedUserImage: json["commentedUserImage"],
    commentType: json["commentType"],
    reportId: json["reportId"],
    reason: json["reason"],
    reportCount: json["reportCount"],
    reportedUsers: json["reportedUsers"] == null ? [] : List<ReportedCommentUser>.from(json["reportedUsers"]!.map((x) => ReportedCommentUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "commentReplyId": commentReplyId,
    "comment": comment,
    "timestamp": timestamp,
    "totalLikes": totalLikes,
    "commentedUserId": commentedUserId,
    "commentedUserName": commentedUserName,
    "commentedUserImage": commentedUserImage,
    "commentType": commentType,
    "reportId": reportId,
    "reason": reason,
    "reportCount": reportCount,
    "reportedUsers": reportedUsers == null ? [] : List<dynamic>.from(reportedUsers!.map((x) => x.toJson())),
  };
}
class ReportedCommentUser {
  String? userId;
  String? name;
  String? profilePicture;
  String? reason;

  ReportedCommentUser({
    this.userId,
    this.name,
    this.profilePicture,
    this.reason,
  });

  factory ReportedCommentUser.fromJson(Map<String, dynamic> json) => ReportedCommentUser(
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
