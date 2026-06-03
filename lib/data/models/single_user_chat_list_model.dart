// To parse this JSON data, do
//
//     final singleUserChatListModel = singleUserChatListModelFromJson(jsonString);

import 'dart:convert';

SingleUserChatListModel singleUserChatListModelFromJson(String str) =>
    SingleUserChatListModel.fromJson(json.decode(str));

String singleUserChatListModelToJson(SingleUserChatListModel data) =>
    json.encode(data.toJson());

class SingleUserChatListModel {
  String? chatId;
  List<ChatMessage>? messages;
  String? requestTab;
  String? requestStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  SingleUserChatListModel({
    this.chatId,
    this.messages,
    this.requestTab,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleUserChatListModel.fromJson(Map<String, dynamic> json) =>
      SingleUserChatListModel(
        chatId: json["chatId"],
        messages: json["messages"] == null
            ? []
            : List<ChatMessage>.from(
                json["messages"]!.map((x) => ChatMessage.fromJson(x))),
        requestTab: json["requestTab"],
        requestStatus: json["requestStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "requestTab": requestTab,
        "requestStatus": requestStatus,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ChatMessage {
  Receiver? sender;
  Receiver? receiver;
  String? message;
  DateTime? createdAt;

  ChatMessage({
    this.sender,
    this.receiver,
    this.message,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        sender:
            json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : Receiver.fromJson(json["receiver"]),
        message: json["message"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
        "message": message,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Receiver {
  String? receiverId;
  String? name;
  String? username;
  String? profilePicture;
  String? senderId;

  Receiver({
    this.receiverId,
    this.name,
    this.username,
    this.profilePicture,
    this.senderId,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        receiverId: json["receiverId"],
        name: json["name"],
        username: json["username"],
        profilePicture: json["profilePicture"],
        senderId: json["senderId"],
      );

  Map<String, dynamic> toJson() => {
        "receiverId": receiverId,
        "name": name,
        "username": username,
        "profilePicture": profilePicture,
        "senderId": senderId,
      };
}
