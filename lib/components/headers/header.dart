import 'package:provider/provider.dart'; 
import 'package:flutter/material.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:vama_mobile/components/headers/guest_header.dart';
import 'package:vama_mobile/components/headers/user_header.dart';

class Header extends StatelessWidget {

  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isLoggedIn
        ? const UserHeader()
        : const GuestHeader();
  }
}
