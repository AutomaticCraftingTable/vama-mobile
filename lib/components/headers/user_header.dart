import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/components/bottom_panel/main_logged_in_layout.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/provider/auth_provider.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final Id = authProvider.Id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero, 
              constraints: const BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                  builder: (context) => const MainLoggedInLayout(),
                    ),
                  (Route<dynamic> route) => false, 
                  );
                },
                child: Image.asset(
                  'lib/assets/logo.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          const Spacer(),
          IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            if (!auth.hasProfile) {
              Navigator.pushNamed(context, '/settings');
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/profile',
                (Route<dynamic> route) => false,
              );
            }
          },
        ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'login') {
                Navigator.pushNamed(context, '/login');
              } else if (value == 'logout') {
                authProvider.logOut();
              }else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Ustawienia'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Wyloguj się'),
                  ),
                ];
            },
          ),
        ],
      ),
    );
  }
}

