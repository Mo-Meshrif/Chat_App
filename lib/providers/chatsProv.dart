import 'package:chat_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lastChat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsProv with ChangeNotifier {
  List<LastChat> _lastChats = [];
  
  String _userId;

  List<LastChat> get lastChats {
    return [..._lastChats];
  }

  void getAuthParameters(String id) {
    _userId = id;
    notifyListeners();
  }

  Future<void> uploadChat(String friendId, String message, bool isMeOpened,
      bool isNotMeOpened,List<User> _users) async {
    final messageTime = Timestamp.now();
    await FirebaseFirestore.instance.collection('chats').doc().set({
      'createdAt': messageTime,
      'from': _userId,
      'to': friendId,
      'message': message,
    });
    final existingIndex =
        _lastChats.indexWhere((element) => element.notme.userId == friendId);
    if (_users.isNotEmpty) {
      if (existingIndex >= 0) {
        _lastChats.removeAt(existingIndex);
        _lastChats.insert(
            0,
            LastChat(
                me: _users.firstWhere((user) => user.userId == _userId),
                notme: _users.firstWhere((user) => user.userId == friendId),
                messageTime: messageTime.toDate(),
                lastMessage: message,
                isMeOpened: isMeOpened,
                isNotMeOpened: isNotMeOpened));
      } else {
        _lastChats.insert(
            0,
            LastChat(
                me: _users.firstWhere((user) => user.userId == _userId),
                notme: _users.firstWhere((user) => user.userId == friendId),
                messageTime: messageTime.toDate(),
                lastMessage: message,
                isMeOpened: isMeOpened,
                isNotMeOpened: isNotMeOpened));
      }
    }
    notifyListeners(); 
  }

  Future<void> getLastChat(List<User>us) async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedData = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots();
    fetchedData.forEach((element) { 
       for(int i =0;i<element.docs.length;i++){
         final existingIndex = _lastChats
              .indexWhere((user) => user.notme.userId == element.docs[i]['to']);
          if (us.isNotEmpty) {
            if (existingIndex >= 0) {
              _lastChats.removeAt(existingIndex);
              _lastChats.insert(
                  0,
                  LastChat(
                      me: us.firstWhere(
                          (user) => user.userId == element.docs[i]['from']),
                      notme: us.firstWhere(
                          (user) => user.userId == element.docs[i]['to']),
                      messageTime: element.docs[i]['createdAt'].toDate(),
                      lastMessage: element.docs[i]['message'],
                      isMeOpened: true,
                      isNotMeOpened: true));
            } else {
              _lastChats.insert(
                  0,
                  LastChat(
                      me: us.firstWhere(
                          (user) => user.userId == element.docs[i]['from']),
                      notme: us.firstWhere(
                          (user) => user.userId == element.docs[i]['to']),
                      messageTime: element.docs[i]['createdAt'].toDate(),
                      lastMessage:element.docs[i]['message'],
                      isMeOpened: true,
                      isNotMeOpened: true));
            }
          }
       }
    });
    notifyListeners();
    final String encodedData = LastChat.encode(_lastChats);
    prefs.setString('lastChatData', encodedData);
  }

    getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('lastChatData')) {
      return;
    }
    final String decodedData = prefs.getString('lastChatData');
    _lastChats = LastChat.decode(decodedData);
    notifyListeners();
  }
}

//       final fetchedData =
//         FirebaseFirestore.instance.collection('chats').snapshots();
//     fetchedData.forEach((element) {
//       if (element.docs.isEmpty) {
//         _lastChats = [];
//         notifyListeners();
//         return;
//       }
//     });
