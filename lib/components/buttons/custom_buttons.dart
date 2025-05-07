import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('PrimaryButton'),
    );
  }
}

class PrimaryBtnHover extends StatelessWidget {
  final VoidCallback onPressed;
  const PrimaryBtnHover({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryHover,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('PrimaryBtnHover'),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SecondaryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('SecondaryButton'),
    );
  }
}

class SecondaryBtnHover extends StatelessWidget {
  final VoidCallback onPressed;
  const SecondaryBtnHover({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryHover,
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('SecondaryBtnHover'),
    );
  }
}

class SecondaryIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SecondaryIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {  
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.flag_outlined),
      label: const Text('SecondaryIconButton'),
    );
  }
}

class SecondaryIconBtnHover extends StatelessWidget {
  final VoidCallback onPressed;
  const SecondaryIconBtnHover({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryHover,
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.flag_outlined),
      label: const Text('SecondaryIconBtnHover'),
    );
  }
}

class SlimButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SlimButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor:AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: const Text('SlimButton'),
    );
  }
}
