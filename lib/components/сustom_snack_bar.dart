import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vama_mobile/theme/light_theme.dart';

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      backgroundColor: isError ? LightTheme.like : Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: LightTheme.textPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: LightTheme.textPrimary, fontSize: 15),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
