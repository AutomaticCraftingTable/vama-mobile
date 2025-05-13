import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/components/main_logged_in_layout.dart';
import 'package:vama_mobile/pages/content_page.dart';
import 'package:vama_mobile/routes/app_routes.dart';
import 'package:vama_mobile/components/auth_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const App(),
    ),
  );
}
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return authProvider.isLoggedIn
              ? const MainLoggedInLayout()
              : const ContentPage();
        },
      ),
    );
  }
}

