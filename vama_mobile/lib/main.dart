import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'routes/app_routes.dart';


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
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
