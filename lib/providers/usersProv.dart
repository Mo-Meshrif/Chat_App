import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersProv with ChangeNotifier {
  String _userId;
  String _userName;
  File _imageUrl;
  void getAuthParameters(String id) {
    _userId = id;
    notifyListeners();
  }

  void getUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  File get imageUrl {
    return _imageUrl;
  }

   String get userName {
    return _userName;
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
  void clear(){
    _imageUrl=null;
    _userName=null;
    notifyListeners();
  }
}
