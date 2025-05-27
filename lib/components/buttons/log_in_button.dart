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
        padding: const EdgeInsets.all(25),
        margin:  const EdgeInsets.symmetric(horizontal: 25) ,
        decoration: BoxDecoration(
            color: LightTheme.text,
                borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
              "Zaloguj się",
               style: TextStyle(
                   color: LightTheme.textWhiteLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
               ),
          ),
        ),
      ),
    );
  }
}
