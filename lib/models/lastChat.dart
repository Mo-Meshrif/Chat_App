import 'dart:convert';
import '../models/user.dart';

class LastChat {
  final DateTime messageTime;
  final User me;
  final User notme;
  final String lastMessage;
  final bool isMeOpened;
  final bool isNotMeOpened;
  LastChat({
    this.me,
    this.messageTime,
    this.notme,
    this.lastMessage,
    this.isMeOpened=false,
    this.isNotMeOpened=false,
  });

  factory LastChat.fromJson(Map<String, dynamic> jsonData) {
    return LastChat(
      messageTime: DateTime.parse(jsonData['messageTime']),
      me: User(
          userId: jsonDecode(jsonData['me'])['userId'],
          userName: jsonDecode(jsonData['me'])['userName'],
          imageUrl: jsonDecode(jsonData['me'])['imageUrl']),
      notme: User(
          userId: jsonDecode(jsonData['notme'])['userId'],
          userName: jsonDecode(jsonData['notme'])['userName'],
          imageUrl: jsonDecode(jsonData['notme'])['imageUrl']),
      lastMessage: jsonData['lastMessage'],
      isMeOpened: jsonData['isMeOpened'],
      isNotMeOpened: jsonData['isNotMeOpened'],
    );
  }

  static Map<String, dynamic> toMap(LastChat lastChat) => {
        'messageTime': lastChat.messageTime.toIso8601String(),
        'me': jsonEncode({
          'userId': lastChat.me.userId,
          'userName': lastChat.me.userName,
          'imageUrl': lastChat.me.imageUrl,
        }),
        'notme': jsonEncode({
          'userId': lastChat.notme.userId,
          'userName': lastChat.notme.userName,
          'imageUrl': lastChat.notme.imageUrl,
        }),
        'lastMessage': lastChat.lastMessage,
        'isMeOpened': lastChat.isMeOpened,
        'isNotMeOpened': lastChat.isNotMeOpened,
      };

  static String encode(List<LastChat> lastChat) => json.encode(
        lastChat
            .map<Map<String, dynamic>>((lastChat) => LastChat.toMap(lastChat))
            .toList(),
      );

  static List<LastChat> decode(String lastChat) =>
      (json.decode(lastChat) as List<dynamic>)
          .map<LastChat>((item) => LastChat.fromJson(item))
          .toList();
}
