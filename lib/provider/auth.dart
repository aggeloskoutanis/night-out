import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    if (_userId != null) return _userId;
    return null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signup(String? email, String? password) async {
    var url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCQpD7ejwAaM65K2SfkDR_SZytJcbCup1U');

    try {
      final response = await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // print(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String? email, String? password) async {
    var url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBRSp0rTPeO31UvkmH00ssYJEbQtp47nms');
    try {
      final response = await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // print(json.decode(response.body));
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void setUserid(String userId) {
    _userId = userId;
  }
}
