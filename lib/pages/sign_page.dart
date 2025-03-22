import 'package:flutter/material.dart';
import 'package:vama_mobile/components/my_button.dart';
import 'package:vama_mobile/components/my_textfield.dart';
import 'package:vama_mobile/components/my_header.dart';

class SignPage extends StatefulWidget{
  const SignPage ({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}
class _SignPageState extends State<SignPage> {
  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn(){}

  //checkbox
  bool _isChecked = false;

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
                      "Please sign up.",
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

                    //Checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            "By checking you accept the Terms of condition",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),

                    //sign in
                    Mybutton(
                      onTap: signUserIn,
                    ),
                  ],
                )
            )
        )
    );
  }
}