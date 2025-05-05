import 'package:flutter/material.dart';
import 'package:vama_mobile/components/header.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        body:
          SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),

              Text(
                'Polubione',
              ),
              const SizedBox(height: 30),
              
            ],
          ),
        ),
          ),
    );
  }
}
