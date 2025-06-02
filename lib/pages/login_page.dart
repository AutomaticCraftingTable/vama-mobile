import 'package:flutter/material.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/components/buttons/log_in_button.dart';
import 'package:vama_mobile/components/custom_textfield.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser(BuildContext context) async {
  final provider = Provider.of<AuthProvider>(context, listen: false);

  if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
    showCustomSnackBar(context, "Wszystkie pola muszą być wypełnione", isError: true);
    return;
  }

  try {
    final success = await provider.login(usernameController.text, passwordController.text);

    if (success) {
      Navigator.pop(context);
    } else {
      showCustomSnackBar(context, "Nieprawidłowy login lub hasło", isError: true);
    }
  } catch (e) {
    showCustomSnackBar(context, "Błąd podczas logowania: ${e.toString()}", isError: true);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: LightTheme.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
         padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 10),
              Text(
                "Witamy w VAMA!",
                style: TextStyle(
                  color: LightTheme.text,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Zaloguj się na swoje konto",
                style: TextStyle(
                  color: LightTheme.textSecondary,
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
                    style: TextStyle(color: LightTheme.textSecondaryLight),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "zarejestruj się",
                      style: TextStyle(
                        color: LightTheme.text,
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
