import 'dart:developer';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/data/models/single_user_chat_list_model.dart';
import 'package:eagle_eye/data/models/typing_user_model.dart';
import 'package:eagle_eye/data/models/user_chat_list_model.dart';
import 'package:eagle_eye/services/socket_service/socket_events.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  // Singleton
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  static late io.Socket socket;

  // Notifier to update UI
  static ValueNotifier<List<UserChatListModel>> userChatListNotifier =
      ValueNotifier<List<UserChatListModel>>([]);
  static ValueNotifier<List<UserChatListModel>> userRequestListNotifier =
      ValueNotifier<List<UserChatListModel>>([]);
  static ValueNotifier<SingleUserChatListModel> singleUserChatNotifier =
      ValueNotifier<SingleUserChatListModel>(SingleUserChatListModel());
  static ValueNotifier<bool> isUserRequested = ValueNotifier<bool>(false);
  static ValueNotifier<TypingUser?> typingUserNotifier = ValueNotifier(null);
  static ValueNotifier<int> userChatUnreadNotifier = ValueNotifier(0);

  static void connect() {
    socket = io.io(
      baseSocketUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'query': {
          'userId': PrefService.getString(PrefService.userId),
        },
        'forceNew': true,
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
      },
    );

    socket.connect();

    socket.onConnect((_) {
      log('🔌 Connected to Socket Server');
      sentUnreadCountRequest();
    });

    socket.onConnectError((err) => log('❌ Connect Error: $err'));
    socket.onDisconnect((_) {
      log('⚡ Disconnected');
      connect();
    });

    socket.on(SocketEvents.userChats, (data) {
      try {
        if (data.isEmpty) {
          userRequestListNotifier.value = [];
          userChatListNotifier.value = [];
        } else {
          if (data[0]['requestTab'] == 'chat') {
            userChatListNotifier.value.clear();
            final newChats = (data as List)
                .map((e) => UserChatListModel.fromJson(e))
                .toList();

            userChatListNotifier.value = newChats;
            log('📩 Updated List: ${userChatListNotifier.value}');
          } else if (data[0]['requestTab'] == 'request') {
            userRequestListNotifier.value.clear();
            final newChats = (data as List)
                .map((e) => UserChatListModel.fromJson(e))
                .toList();
            userRequestListNotifier.value = newChats;
            log('📩 Updated List: ${userRequestListNotifier.value}');
          }
        }
        log('📩 New User Chat: $data');
        log('User Id :- ${PrefService.getString(PrefService.userId)}');
      } catch (e) {
        log("❗ Error parsing userChats: $e");
      }
    });

    socket.on(SocketEvents.newChatMessage, (data) {
      log('📩 New Chat Message: $data');
    });

    socket.on(SocketEvents.recivedUnreadCount, (data) {
      try {
        final unreadChats = data['totalUnreadChats'] ?? 0;
        userChatUnreadNotifier.value = unreadChats;
        log('📩 Updated unread chats: $unreadChats');
      } catch (e) {
        log('❌ Failed to parse unread chats: $e');
      }
    });

    socket.on(SocketEvents.requestAccepted, (data) {
      isUserRequested.value = false;
      log('✅ Request Accepted: $data');
    });

    socket.on(SocketEvents.recivedTypingEvent, (data) {
      try {
        TypingUser user = TypingUser.fromJson(data);
        if (user.typing &&
            user.userId != PrefService.getString(PrefService.userId)) {
          typingUserNotifier.value = user;
        } else {
          typingUserNotifier.value = null;
        }

        log('✅ Typing user updated: ${user.username}');
      } catch (e) {
        log('❌ Failed to parse typing event: $e');
      }
    });

    socket.on(SocketEvents.requestRecieved, (data) {
      try {
        log('📥 Request Received: $data');
        final newUserRequest = UserChatListModel.fromJson(data);
        final currentList = SocketService.userRequestListNotifier.value;
        final updatedList = <UserChatListModel>[
          newUserRequest,
          ...currentList,
        ];
        SocketService.userRequestListNotifier.value = updatedList;
      } catch (e) {
        log('❌ Error handling requestRecieved event: $e');
      }
    });

    socket.on(SocketEvents.reciveMessage, (data) {
      try {
        log('📥 Message Received: $data');

        final newMessage = ChatMessage.fromJson(data);
        final currentModel = singleUserChatNotifier.value;

        final updatedMessage = <ChatMessage>[
          ...(currentModel.messages ?? <ChatMessage>[]),
          newMessage,
        ];

        final updatedModel = SingleUserChatListModel(
          chatId: currentModel.chatId,
          messages: updatedMessage,
          requestTab: currentModel.requestTab,
          requestStatus: currentModel.requestStatus,
          createdAt: currentModel.createdAt,
          updatedAt: DateTime.now(),
        );

        singleUserChatNotifier.value = updatedModel;
        fetchUserChats(requestType: 'chat');
        sentUnreadCountRequest();
      } catch (e) {
        log('❌ Error handling incoming message: $e');
      }
    });

    socket.on(SocketEvents.reciveSingleChat, (data) {
      try {
        singleUserChatNotifier.value == SingleUserChatListModel();
        final parsed = SingleUserChatListModel.fromJson(data);
        singleUserChatNotifier.value = parsed;
        log('📥 Received chat for chatId: ${parsed.chatId}');
      } catch (e) {
        log("❌ Error parsing single chat: $e");
      }
    });
  }

  static void sendMessage({
    required String fromUserId,
    required String toUserId,
    required String message,
  }) {
    final payload = {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'message': message,
    };

    socket.emit(SocketEvents.sendMessage, payload);
    log('📤 Message Sent: $payload');
  }

  static void startTypingEvent({
    required String toUserId,
  }) {
    final payload = {
      'toUserId': toUserId,
    };

    socket.emit(SocketEvents.startTyping, payload);
    log('📤 Start Typing Event Sent: $payload');
  }

  static void stopTypingEvent({
    required String toUserId,
  }) {
    final payload = {
      'toUserId': toUserId,
    };

    socket.emit(SocketEvents.stopTyping, payload);
    log('📤 Start Typing Event Sent: $payload');
  }

  static void sentUnreadCountRequest() {
    socket.emit(SocketEvents.sentUnreadCountRequest, {});
    log('📤 Get Unread Count Event Sent');
  }

  static void handleRequestStatus({
    required String userId,
    required String requestId,
    required String status,
  }) {
    final payload = {
      'userId': userId,
      'requestId': requestId,
      'status': status,
    };

    socket.emit(SocketEvents.handleRequest, payload);
    log('📤 Handle Request Sent: $payload');
  }

  static void fetchUserChats({
    required String requestType,
  }) {
    final payload = {"requestTab": requestType};

    socket.emit(SocketEvents.fetchUserChats, payload);
    log('📤 Fetch User Chats Sent: $payload');
  }

  static void fetchSingleChat({
    required String toUserId,
  }) {
    singleUserChatNotifier.value = SingleUserChatListModel();
    final payload = {
      "fromUserId": PrefService.getString(PrefService.userId),
      "toUserId": toUserId
    };

    socket.emit(SocketEvents.fetchSingleChat, payload);
    log('📤 Fetch User Single Chats Sent: $payload');
  }

  static void disconnect() {
    socket.disconnect();
    log('🛑 Socket Disconnected');
  }
}
