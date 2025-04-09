import 'package:flutter/material.dart';
import 'package:vama_mobile/components/sign_up_button.dart';
import 'package:vama_mobile/components/custom_textfield.dart';
import 'package:vama_mobile/components/header.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class SignPage extends StatefulWidget{
  const SignPage ({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}
class _SignPageState extends State<SignPage> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUser(){
    throw UnimplementedError();
  }

  //checkbox
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
            child:SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child:Column(
                  children: [

                    Header(),

                    const SizedBox(height: 30,),

                    Text(
                      "Witamy w VAMA!",
                      style: TextStyle(
                        color: AppColors.lightTextBlack,
                        fontSize: 24,
                      ),
                    ),

                        Text(
                      "Zarejestruj się, proszę.",
                      style: TextStyle(
                        color: AppColors.lightTextBlack,
                        fontSize: 18,
                      ),
                    ),
                  
                    const SizedBox(height: 20,),

                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Nazwa użytkownika',
                      isPassword: false,
                    ),

                    const SizedBox(height: 20,),

                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Hasło', 
                      isPassword: true,
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: AppColors.lightPrimary,
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
                            style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
                            
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),

                    //sign in
                    SignUpbutton(
                      onTap: signUser,
                    ),
                  ],
                )
            )
        )
    );
  }
}