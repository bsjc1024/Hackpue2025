import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoggedIn = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _user?['name'];
  String? get userEmail => _user?['email'];

  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void clearUser(){
    logout();
  }
}