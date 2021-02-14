import 'dart:io';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersProv with ChangeNotifier {
  List<User> _users = [];
  String _userId;
  String _userName;
  File _imageUrl;
  bool chUser = false;
  void getAuthParameters(String id) {
    _userId = id;
    notifyListeners();
  }

  void getUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  List<User> get users {
    return [..._users];
  }

  User findUserById(String userId) {
    return _users.firstWhere((user) => user.userId == userId,
        orElse: () => null);
  }

  List<User> findOtherUsersById(String userId) {
    return _users.where((user) => user.userId != userId).toList();
  }

  File get imageUrl {
    return _imageUrl;
  }

  String get userName {
    return _userName;
  }

  void changeChUser() {
    chUser = !chUser;
    notifyListeners();
  }

  Future<void> getImageUrl() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final picked = await _picker.getImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
      if (picked != null) {
        _imageUrl = File(picked.path);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> setUsersData() async {
    if (_imageUrl == null) {
      return;
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child('users_image')
        .child('$_userId' + '.jpg');
    await ref.putFile(_imageUrl);
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc('$_userId').set(
      {
        'userId': _userId,
        'userName': _userName,
        'image': url,
      },
    );
  }

  Future<void> getUsersData() async {
    final QuerySnapshot usersData = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('userName')
        .get();
    usersData.docs.forEach((user) {
      final existingIndex =
          _users.indexWhere((oldUser) => oldUser.userId == user.id);
      if (existingIndex >= 0) {
        return;
      } else {
        _users.add(User(
            userId: user.id,
            userName: user.data()['userName'],
            imageUrl: user.data()['image']));
      }
    });
    notifyListeners();
  }

  void clear() {
    _imageUrl = null;
    _userName = null;
    notifyListeners();
  }
}
