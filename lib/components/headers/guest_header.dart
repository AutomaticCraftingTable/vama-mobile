import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/provider/auth_provider.dart';

class GuestHeader extends StatefulWidget {
  const GuestHeader({super.key});

  @override
  State<GuestHeader> createState() => _GuestHeaderState();
}

class _GuestHeaderState extends State<GuestHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
            ),

          const Spacer(),

          if (_isSearching)
            Expanded(
              flex: 5,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
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

