// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hackpue Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            // Check if user is logged in
            return userProvider.isLoggedIn ? const LoginScreen() : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}