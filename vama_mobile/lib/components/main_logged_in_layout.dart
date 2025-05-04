import 'package:flutter/material.dart';
import 'package:vama_mobile/components/custom_bottom_nav_bar.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:provider/provider.dart';

class MainLoggedInLayout extends StatefulWidget {
  final Widget child;

  const MainLoggedInLayout({super.key, required this.child});

  @override
  State<MainLoggedInLayout> createState() => _MainLoggedInLayoutState();
}

class _MainLoggedInLayoutState extends State<MainLoggedInLayout> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: authProvider.isLoggedIn
          ? CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTap,
            )
          : null,  
    );
  }
}

