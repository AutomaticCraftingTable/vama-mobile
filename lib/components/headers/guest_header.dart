import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/components/bottom_panel/main_logged_in_layout.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/provider/auth_provider.dart';

class GuestHeader extends StatefulWidget {
  const GuestHeader({super.key});

  @override
  State<GuestHeader> createState() => _GuestHeaderState();
}

class _GuestHeaderState extends State<GuestHeader> {

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);
    final authProvider = Provider.of<AuthProvider>(context);

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
                  (Route<dynamic>route) => false,
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

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'login') {
                Navigator.pushNamed(context, '/login');
              } else if (value == 'logout') {
                authProvider.logOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return 
                   [
                      const PopupMenuItem<String>(
                        value: 'login',
                        child: Text('Zaloguj się'),
                      ),
                    ];
            },
          ),
        ],
      ),
    );
  }
}

