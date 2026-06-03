// To parse this JSON data, do
//
//     final postCommentModel = postCommentModelFromJson(jsonString);

import 'dart:convert';

PostCommentModel postCommentModelFromJson(String str) => PostCommentModel.fromJson(json.decode(str));

String postCommentModelToJson(PostCommentModel data) => json.encode(data.toJson());

List<PostCommentData> eventNewsDetailModelFromJson(String str) => List<PostCommentData>.from(json.decode(str).map((x) => PostCommentData.fromJson(x)));

String eventNewsDetailModelToJson(List<PostCommentData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostCommentModel {
  List<PostCommentData>? body;

  PostCommentModel({
    this.body,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) => PostCommentModel(
    body: json["body"] == null ? [] : List<PostCommentData>.from(json["body"]!.map((x) => PostCommentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class PostCommentData {
  String? userId;
  String? name;
  String? profileImage;
  String? comment;
  DateTime? timestamp;
  String? totalLikes;
  bool? isLiked;
  bool? isDeleted;
  String? totalReplies;
  List<PostCommentData>? replies;
  String? id;

  PostCommentData({
    this.userId,
    this.name,
    this.profileImage,
    this.comment,
    this.timestamp,
    this.totalLikes,
    this.isLiked,
    this.isDeleted,
    this.totalReplies,
    this.replies,
    this.id,
  });

  factory PostCommentData.fromJson(Map<String, dynamic> json) => PostCommentData(
    userId: json["userId"],
    name: json["name"],
    profileImage: json["profileImage"],
    comment: json["comment"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    totalLikes: json["totalLikes"],
    isLiked: json["isLiked"],
    isDeleted: json["isDeleted"],
    totalReplies: json["totalReplies"],
    replies: json["replies"] == null ? [] : List<PostCommentData>.from(json["replies"]!.map((x) => PostCommentData.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "profileImage": profileImage,
    "comment": comment,
    "timestamp": timestamp?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLiked": isLiked,
    "isDeleted": isDeleted,
    "totalReplies": totalReplies,
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
    "_id": id,
  };
}
