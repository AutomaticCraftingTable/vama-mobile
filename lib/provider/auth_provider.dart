import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart'; 

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _registeredNickname;
  String? _registeredPassword;
  
  String? _nickname;
  String? _token;

  bool _isModerator = false;
  bool get isModerator => _isModerator;


  bool _isModerator = false;
  bool get isModerator => _isModerator;


  int? _Id;
  int? get Id => _Id;

  String? get nickname => _nickname;
  bool get isLoggedIn => _isLoggedIn;
  bool hasProfile = false;
  

 Future<bool> register(
  String nickname,
  String password,
  String passwordConfirmation,
) async {
  try {
    final api = ApiService();

    final response = await api.dio.post(
      '/api/auth/register',
      data: {
        'email': nickname,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _registeredNickname = nickname; 
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

Future<bool> login(String email, String password) async {
  try {
    final api = ApiService(); 
    final response = await api.dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
      options: Options(validateStatus: (status) => status != null && status < 500),
    );

    if (response.statusCode == 200) {
      final token = response.data['token'] as String?;
      if (token == null) return false;

      _isLoggedIn = true;
      _nickname = email;
      _isModerator = email.toLowerCase().contains('mod');
      final idValue = response.data['user']['id'];
      _Id = idValue is int ? idValue : int.parse(idValue.toString());
      api.setToken(token); 

      notifyListeners();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Error during login: $e");
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

 void setHasProfile(bool value) {
    hasProfile = value;
    notifyListeners();
  }
  void setModerator(bool value) {
    _isModerator = value;
    notifyListeners();
  }
  void setToken(String token) {
  _token = token;
  ApiService().setToken(token); 
}
}
