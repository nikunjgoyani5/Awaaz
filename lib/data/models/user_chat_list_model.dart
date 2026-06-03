// To parse this JSON data, do
//
//     final userChatListModel = userChatListModelFromJson(jsonString);

import 'dart:convert';

List<UserChatListModel> userChatListModelFromJson(String str) =>
    List<UserChatListModel>.from(
        json.decode(str).map((x) => UserChatListModel.fromJson(x)));

String userChatListModelToJson(List<UserChatListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserChatListModel {
  String? id;
  FromUser? fromUser;
  FromUser? toUser;
  List<Message>? messages;
  String? requestTab;
  String? requestStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? unreadCount;

  UserChatListModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.messages,
    this.requestTab,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
    this.unreadCount,
  });

  factory UserChatListModel.fromJson(Map<String, dynamic> json) =>
      UserChatListModel(
        id: json["_id"],
        fromUser: json["fromUser"] == null
            ? null
            : FromUser.fromJson(json["fromUser"]),
        toUser:
            json["toUser"] == null ? null : FromUser.fromJson(json["toUser"]),
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
        requestTab: json["requestTab"],
        unreadCount: json["unreadCount"],
        requestStatus: json["requestStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fromUser": fromUser?.toJson(),
        "toUser": toUser?.toJson(),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "requestTab": requestTab,
        "unreadCount": unreadCount,
        "requestStatus": requestStatus,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class FromUser {
  String? fromUserId;
  String? name;
  String? username;
  String? profilePicture;
  String? receiverId;
  String? senderId;
  String? toUserId;

  FromUser({
    this.fromUserId,
    this.name,
    this.username,
    this.profilePicture,
    this.receiverId,
    this.senderId,
    this.toUserId,
  });

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
        fromUserId: json["fromUserId"],
        name: json["name"],
        username: json["username"],
        profilePicture: json["profilePicture"],
        receiverId: json["receiverId"],
        senderId: json["senderId"],
        toUserId: json["toUserId"],
      );

  Map<String, dynamic> toJson() => {
        "fromUserId": fromUserId,
        "name": name,
        "username": username,
        "profilePicture": profilePicture,
        "receiverId": receiverId,
        "senderId": senderId,
        "toUserId": toUserId,
      };
}

class Message {
  FromUser? sender;
  FromUser? receiver;
  String? message;
  DateTime? createdAt;
  bool? read;

  Message({
    this.sender,
    this.receiver,
    this.message,
    this.createdAt,
    this.read = true,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender:
            json["sender"] == null ? null : FromUser.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : FromUser.fromJson(json["receiver"]),
        message: json["message"],
        read: json["read"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
        "message": message,
        "read": read,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
