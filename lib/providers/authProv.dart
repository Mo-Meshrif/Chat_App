import 'dart:async';
import 'dart:convert';

import 'package:chat_app/httpExcptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProv with ChangeNotifier {
  String _token, _userId;
  DateTime _expireTime;
  Timer _authTimer;
  bool signInState = true;

  void sign() {
    signInState = !signInState;
    notifyListeners();
  }

  String get token {
    if (_token != null &&
        _expireTime != null &&
        _expireTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _auth(String email, String password, String urlSegment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAQLNbFnliJuMrESr8LmjhPBdn0p331REg';
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responsBody = jsonDecode(response.body);
      if (responsBody['error'] != null) {
        throw HttpException(responsBody['error']['message']);
      }
      _token = responsBody['idToken'];
      _userId = responsBody['localId'];
      _expireTime = DateTime.now()
          .add(Duration(seconds: int.parse(responsBody['expiresIn'])));
      notifyListeners();
      final date = jsonEncode({
        'token': _token,
        'userId': userId,
        'expireTime': _expireTime.toString()
      });
      prefs.setString('Date', date);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _auth(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _auth(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Date')) {
      return false;
    }
    final extractedDate = jsonDecode(prefs.getString('Date'));
    final expireTime = DateTime.parse(extractedDate['expireTime']);
    if (expireTime.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedDate['token'];
    _userId = extractedDate['userId'];
    _expireTime = expireTime;
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expireTime = null;
    if (_authTimer != null) {
      _authTimer = null;
      _authTimer.cancel();
    }
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    if (!_expireTime.isBefore(DateTime.now())) {
      _authTimer = Timer(
          Duration(seconds: _expireTime.difference(DateTime.now()).inSeconds),
          logout);
    }
  }
}
