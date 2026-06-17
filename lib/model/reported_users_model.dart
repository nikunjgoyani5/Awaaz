// To parse this JSON data, do
//
//     final getAllReportedUsers = getAllReportedUsersFromJson(jsonString);

import 'dart:convert';

GetAllReportedUsers getAllReportedUsersFromJson(String str) => GetAllReportedUsers.fromJson(json.decode(str));

String getAllReportedUsersToJson(GetAllReportedUsers data) => json.encode(data.toJson());

class GetAllReportedUsers {
  String? message;
  List<ReportedUser>? body;
  bool? status;

  GetAllReportedUsers({
    this.message,
    this.body,
    this.status,
  });

  factory GetAllReportedUsers.fromJson(Map<String, dynamic> json) => GetAllReportedUsers(
    message: json["message"],
    body: json["body"] == null ? [] : List<ReportedUser>.from(json["body"]!.map((x) => ReportedUser.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
    "status": status,
  };
}

class ReportedUser {
  String? reportedUserId;
  String? reportedUserName;
  bool isBlocked;
  String? reportedUserProfilePicture;
  int? reportedCounts;
  List<ReportOfUser>? reports;

  ReportedUser({
    this.reportedUserId,
    this.reportedUserName,
    this.reportedUserProfilePicture,
    this.reportedCounts,
    this.reports,
    this.isBlocked= false,
  });

  factory ReportedUser.fromJson(Map<String, dynamic> json) => ReportedUser(
    reportedUserId: json["reportedUserId"],
    reportedUserName: json["reportedUserName"],
    reportedUserProfilePicture: json["reportedUserProfilePicture"],
    reportedCounts: json["reportedCounts"],
    isBlocked: json["isBlocked"],
    reports: json["reports"] == null ? [] : List<ReportOfUser>.from(json["reports"]!.map((x) => ReportOfUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reportedUserId": reportedUserId,
    "reportedUserName": reportedUserName,
    "reportedUserProfilePicture": reportedUserProfilePicture,
    "reportedCounts": reportedCounts,
    "isBlocked": isBlocked,
    "reports": reports == null ? [] : List<dynamic>.from(reports!.map((x) => x.toJson())),
  };
}

class ReportOfUser {
  String? userId;
  String? name;
  String? profilePicture;
  String? reason;

  ReportOfUser({
    this.userId,
    this.name,
    this.profilePicture,
    this.reason,
  });

  factory ReportOfUser.fromJson(Map<String, dynamic> json) => ReportOfUser(
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
