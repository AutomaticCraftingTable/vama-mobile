import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/pages/login_page.dart';
import 'package:vama_mobile/pages/settings_page.dart';
import 'package:vama_mobile/pages/sign_page.dart';
import 'package:vama_mobile/pages/user_profile_page.dart';
import 'package:vama_mobile/routes/page_transitions.dart';
import 'package:vama_mobile/pages/content_page.dart';
import 'package:vama_mobile/pages/favorites_page.dart';
import 'package:vama_mobile/pages/subscriptions_page.dart';
import 'package:vama_mobile/pages/add_article_page.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return slideFromLeft(LoginPage());
      case '/signup':
        return slideFromRight(SignPage());
      case '/home':
        return slideFromRight(ContentPage());
      case '/favorites':
        return slideFromRight(FavoritesPage());
      case '/subscriptions':
        return slideFromLeft(Subscriptions());
      case '/add-article':
        return fadeTransition(AddArticle());
        case '/settings':
        return fadeTransition(SettingsPage());
        case '/profile':
        final maybeNickname = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            final profileUsername = maybeNickname ?? auth.nickname!;
            return UserProfilePage(nickname: profileUsername);
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
    }
  }
}