import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/theme/app_colors.dart';
import 'package:vama_mobile/components/auth_provider.dart';


class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

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
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          const SizedBox(width: 5),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Szukaj...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: AppColors.buttonGrey,
                filled: true,
              ),
            ),
          ),

          const SizedBox(width: 5),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print("User Profile");
            },
          ),

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
              return authProvider.isLoggedIn
                  ? [
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Wyloguj się'),
                      ),
                    ]
                  : [
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
