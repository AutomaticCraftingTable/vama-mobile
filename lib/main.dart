import 'package:flutter/material.dart';
import 'package:vama_mobile/pages/sign_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}
// test
class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override
  Widget build (BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),

      //Routes
      routes: {
        '/login':(context)=>LoginPage(),
        '/signUp':(context)=>SignPage(),
      },
    );
  }
}
