import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
  });

  @override
  State<CustomTextField> createState() => TextFieldState();
}

class TextFieldState extends State<CustomTextField> {

  late bool isPasswordHidden;

  @override
  void initState() {
    super.initState();
    isPasswordHidden = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
Widget build(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: TextField(
      controller: widget.controller,
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        filled: true,
        fillColor: LightTheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: LightTheme.borderEnabled),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: LightTheme.borderFocused),
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(color: LightTheme.textSecondaryLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: LightTheme.textSecondaryLight,
                ),
                onPressed: _toggleVisibility,
              )
            : null,
      ),
    ),
  );
}
}


