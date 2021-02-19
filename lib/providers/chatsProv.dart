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

  Future<void> uploadChat(
      String friendId, String message, List<User> _users) async {
    final messageTime = Timestamp.now();
    await FirebaseFirestore.instance.collection('chats').doc().set({
      'createdAt': messageTime,
      'from': _userId,
      'to': friendId,
      'message': message,
    });
    final existingFIndex =
        _lastChats.indexWhere((element) => element.notme.userId == friendId);
    final existingUIndex =
        _lastChats.indexWhere((element) => element.notme.userId == _userId);
    if (_users.isNotEmpty) {
      if (existingFIndex >= 0) {
        _lastChats.removeAt(existingFIndex);
        _lastChats.insert(
            0,
            LastChat(
              me: _users.firstWhere((user) => user.userId == _userId),
              notme: _users.firstWhere((user) => user.userId == friendId),
              messageTime: messageTime.toDate(),
              lastMessage: message,
            ));
      } else if (existingUIndex >= 0) {
        _lastChats.removeAt(existingUIndex);
        _lastChats.insert(
            0,
            LastChat(
              me: _users.firstWhere((user) => user.userId == friendId),
              notme: _users.firstWhere((user) => user.userId == _userId),
              messageTime: messageTime.toDate(),
              lastMessage: message,
            ));
      } else {
        _lastChats.insert(
            0,
            LastChat(
              me: _users.firstWhere((user) => user.userId == _userId),
              notme: _users.firstWhere((user) => user.userId == friendId),
              messageTime: messageTime.toDate(),
              lastMessage: message,
            ));
      }
    }
    notifyListeners();
  }

  Future<void> getLastChat(List<User> us) async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedData = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots();
    fetchedData.forEach((element) {
      for (int i = 0; i < element.docs.length; i++) {
        final existingFIndex = _lastChats
            .indexWhere((user) => user.notme.userId == element.docs[i]['to']);
        final existingUIndex = _lastChats
            .indexWhere((user) => user.notme.userId == element.docs[i]['from']);
        if (us.isNotEmpty) {
          if (existingFIndex >= 0) {
            _lastChats.removeAt(existingFIndex);
            _lastChats.insert(
                0,
                LastChat(
                  me: us.firstWhere(
                      (user) => user.userId == element.docs[i]['from']),
                  notme: us.firstWhere(
                      (user) => user.userId == element.docs[i]['to']),
                  messageTime: element.docs[i]['createdAt'].toDate(),
                  lastMessage: element.docs[i]['message'],
                ));
          } else if (existingUIndex >= 0) {
            _lastChats.removeAt(existingUIndex);
            _lastChats.insert(
                0,
                LastChat(
                  me: us.firstWhere(
                      (user) => user.userId == element.docs[i]['to']),
                  notme: us.firstWhere(
                      (user) => user.userId == element.docs[i]['from']),
                  messageTime: element.docs[i]['createdAt'].toDate(),
                  lastMessage: element.docs[i]['message'],
                ));
          } else {
            _lastChats.insert(
                0,
                LastChat(
                  me: us.firstWhere(
                      (user) => user.userId == element.docs[i]['from']),
                  notme: us.firstWhere(
                      (user) => user.userId == element.docs[i]['to']),
                  messageTime: element.docs[i]['createdAt'].toDate(),
                  lastMessage: element.docs[i]['message'],
                ));
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

  clearSavedDataIfNoChats() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedData =
        FirebaseFirestore.instance.collection('chats').snapshots();
    fetchedData.forEach((element) {
      if (element.docs.isEmpty) {
        _lastChats = [];
        notifyListeners();
        prefs.remove('lastChatData');
      }
    });
  }

  deleteMessage(String docId) async {
    FirebaseFirestore.instance.collection('chats').doc(docId).delete();
  }

  deleteChat(String userId, String friendId) {
    FirebaseFirestore.instance
        .collection('chats')
        .snapshots()
        .forEach((element) {
      for (int i = 0; i < element.docs.length; i++) {
        if ((element.docs[i]['from'] == userId &&
                element.docs[i]['to'] == friendId) ||
            (element.docs[i]['to'] == userId &&
                element.docs[i]['from'] == friendId)) {
          FirebaseFirestore.instance
              .collection('chats')
              .doc(element.docs[i].id)
              .delete();
        }
      }
    });
  }
}
