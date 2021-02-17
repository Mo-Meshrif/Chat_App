import 'dart:convert';

class User {
  final String userId;
  final String userName;
  final String imageUrl;
  User({
    this.userId,
    this.userName,
    this.imageUrl,
  });
  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      userId: jsonData['userId'],
      userName: jsonData['userName'],
      imageUrl: jsonData['imageUrl'],
    );
  }

  static Map<String, dynamic> toMap(User user) => {
        'userId': user.userId,
        'userName': user.userName,
        'imageUrl': user.imageUrl,
      };

  static String encode(List<User> user) => json.encode(
        user.map<Map<String, dynamic>>((user) => User.toMap(user)).toList(),
      );

  static List<User> decode(String user) => (json.decode(user) as List<dynamic>)
      .map<User>((item) => User.fromJson(item))
      .toList();
}
