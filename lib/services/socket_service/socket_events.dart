class SocketEvents {
  static const String sendMessage = 'SEND_MESSAGE';
  static const String fetchUserChats = 'FETCH_USER_CHATS';
  static const String userChats = 'USER_CHATS';
  static const String newChatMessage = 'NEW_CHAT_MESSAGE';
  static const String requestAccepted = 'REQUEST_ACCEPTED';
  static const String requestRecieved = 'REQUEST_RECEIVED';
  static const String handleRequest = 'HANDLE_REQUEST';
  static const String fetchSingleChat = 'FETCH_SINGLE_CHAT';
  static const String reciveSingleChat = 'RECEIVE_SINGLE_CHAT';
  static const String reciveMessage = 'RECEIVE_MESSAGE';
  static const String startTyping = 'START_TYPING';
  static const String stopTyping = 'STOP_TYPING';
  static const String recivedTypingEvent = 'TYPING';
  static const String sentUnreadCountRequest = 'GET_UNREAD_STATS';
  static const String recivedUnreadCount = 'UNREAD_STATS';
}
