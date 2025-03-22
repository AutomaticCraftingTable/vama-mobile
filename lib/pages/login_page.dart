import 'package:flutter/material.dart';
import 'package:vama_mobile/components/my_button.dart';
import 'package:vama_mobile/components/my_textfield.dart';
import 'package:vama_mobile/components/my_header.dart';

class LoginPage extends StatelessWidget{
   LoginPage ({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
   void loginUserIn(){}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Center(
          child:Column(
            children: [

              //Header
              Myheader(),

              const SizedBox(height: 30,),

              //Welcome
              Text(
                  "Welcome to VAMA!",
                style: TextStyle(
                    color: Colors.black,
                        fontSize: 32,
                ),
              ),

              //Second Text
              Text(
                "Please log in to your account.",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 24,
                   ),
              ),

              const SizedBox(height: 20,),

              //Username Textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 20,),

              //Password Textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 20,),

              //login in
              Mybutton(
                onTap: loginUserIn,
              ),
            ],
          )
        )
      )
    );
  }
}