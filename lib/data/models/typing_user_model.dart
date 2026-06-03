class TypingUser {
  final String name;
  final String username;
  final String profilePicture;
  final String userId;
  final String receiverId ;
  final bool typing;

  TypingUser({
    required this.name,
    required this.username,
    required this.profilePicture,
    required this.userId,
    required this.typing,
    required this.receiverId,
  });

  factory TypingUser.fromJson(Map<String, dynamic> json) {
    return TypingUser(
      name: json['name'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      userId: json['userId'],
      receiverId: json['receiverId'],
      typing: json['typing'] ?? false,
    );
  }
}
