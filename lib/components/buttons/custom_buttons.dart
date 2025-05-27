import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:LightTheme.primary,
        foregroundColor: LightTheme.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('PrimaryButton'),
    );
  }
}
class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;  

  const SecondaryButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightTheme.secondary,
        foregroundColor: LightTheme.text,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),  
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(8),  
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
