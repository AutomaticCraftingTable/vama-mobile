import 'package:flutter/material.dart';
import 'package:vama_mobile/components/buttons/sign_up_button.dart';
import 'package:vama_mobile/components/custom_textfield.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/components/auth_provider.dart';
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
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Musisz zaakceptować Warunki korzystania.")),
      );
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);
    final success = await provider.register(usernameController.text, passwordController.text);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rejestracja zakończona sukcesem! Możesz się teraz zalogować.")),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Użytkownik już zarejestrowany.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: LightTheme.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const Header(),

              const SizedBox(height: 30),

              Text(
                "Witamy w VAMA!",
                style: TextStyle(
                  color: LightTheme.text,
                  fontSize: 24,
                ),
              ),

              Text(
                "Zarejestruj się, proszę.",
                style: TextStyle(
                  color: LightTheme.text,
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
                      style: TextStyle(fontSize: 13, color: LightTheme.textSecondaryLight),
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
                    style: TextStyle(color: LightTheme.textSecondaryLight),
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
