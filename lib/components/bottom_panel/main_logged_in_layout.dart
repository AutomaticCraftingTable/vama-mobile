import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/bottom_panel/custom_bottom_nav_bar.dart';
import 'package:vama_mobile/pages/add_article_page.dart';
import 'package:vama_mobile/pages/content_page.dart';
import 'package:vama_mobile/pages/favorites_page.dart';
import 'package:vama_mobile/pages/subscriptions_page.dart';

class MainLoggedInLayout extends StatefulWidget {
  const MainLoggedInLayout({super.key});

  @override
  State<MainLoggedInLayout> createState() => _MainLoggedInLayoutState();
}

class _MainLoggedInLayoutState extends State<MainLoggedInLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ContentPage(),
    Subscriptions(),
    AddArticle(),
    FavoritesPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: authProvider.isLoggedIn
          ? CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTap,
            )
          : null,
    );
  }
}