import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/components/auth_provider.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
            ),

          const Spacer(),

          if (_isSearching)
            Expanded(
              flex: 5,
              child: TextField(
                controller: _searchController,
                autofocus: true,
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
                  fillColor: LightTheme.buttonGrey,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _isSearching = false);
                    },
                  ),
                ),
                onSubmitted: (value) {
                  print("Szukaj: $value"); 
                },
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() => _isSearching = true);
              },
            ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: ()
                 {
                Navigator.pushNamed(
                  context,
                  '/profile',
                );
              
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

