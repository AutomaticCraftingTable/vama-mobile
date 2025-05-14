import 'package:flutter/material.dart';
import 'package:vama_mobile/components/headers/header.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required userId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              Text('UserProfilePage'),
              const SizedBox(height: 30),
            ],
          ),
        ),
        ),
    );
  }
}