import 'package:flutter/material.dart';
import 'package:vama_mobile/pages/login_page.dart';
import 'package:vama_mobile/pages/sign_page.dart';
import 'package:vama_mobile/routes/page_transitions.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return slideFromLeft(LoginPage());
      case '/signup':
        return slideFromRight(SignPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}