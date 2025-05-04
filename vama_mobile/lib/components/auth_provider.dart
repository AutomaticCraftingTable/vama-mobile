import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _registeredUsername;
  String? _registeredPassword;

  bool get isLoggedIn => _isLoggedIn;

  
  bool register(String username, String password) {
    if (_registeredUsername == null && _registeredPassword == null) {
      _registeredUsername = username;
      _registeredPassword = password;
      notifyListeners();
      return true;
    }
    return false; 
  }
 
  bool login(String username, String password) {
    if (username == _registeredUsername && password == _registeredPassword) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false; 
  }

  void logOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
