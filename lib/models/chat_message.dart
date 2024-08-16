import 'package:intl/intl.dart';

class ChatUser {
  final String id;
  final String name;

  const ChatUser({
    required this.id,
    required this.name,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['ID'] as String,
      name: json['NAME'] as String,
    );
  }

}

class ChatMessage {
  final String id;
  final DateTime added;
  final String user_name;
  final String user_id;
  final String message;

  const ChatMessage({
    required this.id,
    required this.added,
    required this.user_name,
    required this.user_id,
    required this.message,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['ID'] as String,
      added: DateFormat("y-M-d H:m:s").parse(json['ADDED']),
      user_name: json['NAME'] as String,
      user_id: json['USER_ID'] as String,
      message: json['MESSAGE'] as String,
    );
  }

}
