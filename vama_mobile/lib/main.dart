import 'package:flutter/material.dart';
import 'package:vama_mobile/pages/sign_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget{
  const App ({super.key});

  @override
  Widget build (BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),

      
      routes: {
        '/login':(context)=>LoginPage(),
        '/signup':(context)=>SignPage(),
      },
    );
  }
}
