import 'package:flutter/material.dart';
import 'package:vama_mobile/pages/login_page.dart';
import 'package:vama_mobile/pages/sign_page.dart';
import 'package:vama_mobile/routes/page_transitions.dart';
import 'package:vama_mobile/pages/content_page.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return slideFromLeft(LoginPage());
      case '/signup':
        return slideFromRight(SignPage());
      case '/home':
        return slideFromRight(ContentPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}