import 'package:flutter/material.dart';
import 'package:vama_mobile/components/log_in_button.dart';
import 'package:vama_mobile/components/textfield.dart';
import 'package:vama_mobile/components/header.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Myheader(),

              const SizedBox(height: 30),

              Text(
                "Witamy w VAMA!",
                style: TextStyle(
                  color: AppColors.lightTextBlack,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Zaloguj się na swoje konto.",
                style: TextStyle(
                  color: AppColors.lightTextBlack,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              MyTextField(
                controller: usernameController,
                hintText: 'Nazwa użytkownika',
                isPassword: false,
              ),

              const SizedBox(height: 20),

              MyTextField(
                controller: passwordController,
                hintText: 'Hasło',
                isPassword: true,
              ),

              const SizedBox(height: 30),

              Mybutton(
                onTap: loginUser,
              ),

              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }
}
