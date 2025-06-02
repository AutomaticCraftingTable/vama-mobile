import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class LogInButton extends StatelessWidget {

  final Function()? onTap;

  const LogInButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin:  const EdgeInsets.symmetric(horizontal: 25) ,
        decoration: BoxDecoration(
            color: LightTheme.primary,
                borderRadius: BorderRadius.zero,
        ),
        child: const Center(
          child: Text(
              "Zaloguj się",
               style: TextStyle(
                   color: LightTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
               ),
          ),
        ),
      ),
    );
  }
}
