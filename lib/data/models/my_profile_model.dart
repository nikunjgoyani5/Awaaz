// To parse this JSON data, do
//
//     final myProfileModel = myProfileModelFromJson(jsonString);

import 'dart:convert';

import 'other_user_profile_model.dart';

MyProfileModel myProfileModelFromJson(String str) =>
    MyProfileModel.fromJson(json.decode(str));

String myProfileModelToJson(MyProfileModel data) => json.encode(data.toJson());

class MyProfileModel {
  MyProfile? myProfile;

  MyProfileModel({
    this.myProfile,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
        myProfile:
            json["body"] == null ? null : MyProfile.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "body": myProfile?.toJson(),
      };
}

class MyProfile {
  String? id;
  String? name;
  String? userName;
  String? profilePicture;
  int? userRadius;
  String? email;
  String? phone;
  String? countryCode;
  DateTime? dateOfBirth;
  String? allBroadcastCounts;
  String? totalApprovedEventViews;
  String? verifiedEventCounts;
  List<AllBroadcast>? allBroadcasts;
  List<AllBroadcast>? verifiedEventPosts;
  List<AllBroadcast>? savedPosts;

  MyProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.countryCode,
    this.userName,
    this.profilePicture,
    this.userRadius,
    this.dateOfBirth,
    this.allBroadcastCounts,
    this.totalApprovedEventViews,
    this.verifiedEventCounts,
    this.allBroadcasts,
    this.verifiedEventPosts,
    this.savedPosts,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["mobileNumber"],
        countryCode: json["countryCode"],
        userName: json["username"],
        profilePicture: json["profilePicture"],
        userRadius: json["userRadius"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        allBroadcastCounts: json["allBroadcastCounts"],
        totalApprovedEventViews: json["totalApprovedEventViews"],
        verifiedEventCounts: json["verifiedEventCounts"],
        allBroadcasts: json["allBroadcasts"] == null
            ? []
            : List<AllBroadcast>.from(
                json["allBroadcasts"]!.map((x) => AllBroadcast.fromJson(x))),
        verifiedEventPosts: json["verifiedEventPosts"] == null
            ? []
            : List<AllBroadcast>.from(json["verifiedEventPosts"]!
                .map((x) => AllBroadcast.fromJson(x))),
        savedPosts: json["saveEventPost"] == null
            ? []
            : List<AllBroadcast>.from(
                json["saveEventPost"]!.map((x) => AllBroadcast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mobileNumber": phone,
        "email": email,
        "countryCode": countryCode,
        "username": userName,
        "profilePicture": profilePicture,
        "userRadius": userRadius,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "allBroadcastCounts": allBroadcastCounts,
        "totalApprovedEventViews": totalApprovedEventViews,
        "verifiedEventCounts": verifiedEventCounts,
        "allBroadcasts": allBroadcasts == null
            ? []
            : List<dynamic>.from(allBroadcasts!.map((x) => x)),
        "verifiedEventPosts": verifiedEventPosts == null
            ? []
            : List<dynamic>.from(verifiedEventPosts!.map((x) => x)),
        "saveEventPost": savedPosts == null
            ? []
            : List<dynamic>.from(savedPosts!.map((x) => x)),
      };
}
