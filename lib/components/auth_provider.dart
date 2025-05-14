import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart'; 

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _registeredUsername;
  String? _registeredPassword;

  bool get isLoggedIn => _isLoggedIn;
  

  Future<bool> register(String username, String password) async {
    try {
      final api = ApiService();

      final response = await api.dio.post('/api/auth/register', data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        _registeredUsername = username; 
        _registeredPassword = password;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
  try {
    final api = ApiService();

    final response = await api.dio.post('/api/auth/login', data: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      _isLoggedIn = true;
      print("Login successful");
      notifyListeners(); 
      return true;
    } else {
      print("Login failed");
      return false; 
    }
  } catch (e) {
    print("Error $e");
    return false;  
  }
}

  void logOut() async {
  try {
    final api = ApiService();
    await api.dio.post('/api/auth/logout');

    _isLoggedIn = false;
    notifyListeners();
  } catch (e) {
    print("Logout error: $e");
    _isLoggedIn = false; 
    notifyListeners();
  }
}
}
