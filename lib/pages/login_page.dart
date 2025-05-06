import 'package:flutter/material.dart';
import 'package:vama_mobile/components/header.dart';
import 'package:vama_mobile/components/log_in_button.dart';
import 'package:vama_mobile/components/custom_textfield.dart';
import 'package:vama_mobile/theme/app_colors.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    final success = await provider.login(usernameController.text, passwordController.text);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nieprawidłowy login lub hasło")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              const SizedBox(height: 30),
              Text(
                "Witamy w VAMA!",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Zaloguj się na swoje konto.",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: usernameController,
                hintText: 'Nazwa użytkownika',
                isPassword: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Hasło',
                isPassword: true,
              ),
              const SizedBox(height: 30),
              LogInButton(
                onTap: () => loginUser(context),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "albo ",
                    style: TextStyle(color: AppColors.textSecondaryLight),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "zarejestruj się",
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
