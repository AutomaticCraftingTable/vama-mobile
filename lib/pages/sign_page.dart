import 'package:flutter/material.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/buttons/sign_up_button.dart';
import 'package:vama_mobile/components/custom_textfield.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/components/headers/header.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isChecked = false;

  void signUser() async {
  if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
    showCustomSnackBar(context, "Wszystkie pola muszą być wypełnione", isError: true);
    return;
  }

  if (!_isChecked) {
    showCustomSnackBar(context, "Musisz zaakceptować Warunki korzystania.", isError: true);
    return;
  }

  final provider = Provider.of<AuthProvider>(context, listen: false);
  final success = await provider.register(usernameController.text, passwordController.text);

  if (success) {
    showCustomSnackBar(context, "Rejestracja zakończona sukcesem! Możesz się teraz zalogować.");
    Navigator.pushNamed(context, '/login');
  } else {
    showCustomSnackBar(context, "Użytkownik już zarejestrowany.", isError: true);
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

              Text(
                "Zarejestruj się, proszę",
                style: TextStyle(
                  color: LightTheme.textSecondary,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: LightTheme.checkBox,
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      "Zaznaczając, akceptujesz Warunki korzystania.",
                      style: TextStyle(fontSize: 13, color: LightTheme.textDimmed),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SignUpButton(
                onTap: signUser,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "albo ",
                    style: TextStyle(color: LightTheme.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "zaloguj się",
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
