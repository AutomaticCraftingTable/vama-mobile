import 'package:flutter/material.dart';
import 'package:vama_mobile/components/header.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({super.key});

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
              Text('Subskrypcje'),
              const SizedBox(height: 30),
            ],
          ),
        ),
        ),
    );
  }
}