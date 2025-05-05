import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: isPasswordHidden,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.borderEnabled),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.borderFocused),
          ),
          fillColor: AppColors.secondary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.textSecondaryLight),

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondaryLight,
                  ),
                  onPressed: _toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}


