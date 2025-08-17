import 'package:flutter/material.dart';
import 'screen/login_screen.dart'; 
import 'screen/register.dart';
import 'screen/disponibilidad_screen.dart';
import 'screen/exam_ubication.dart';
import 'screen/home_screen.dart';
import 'screen/espanol_screen.dart';
import 'screen/biologia_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Hackpue Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => const RegistroScreen(),
        '/login': (context) => const LoginScreen(),        
        '/disponibilidad': (context) => const DisponibilidadScreen(),
        '/exam': (context) => const ExamenView(),
        '/home': (context) => const HomeScreen(),
        '/espanol': (context) => const EspanolScreen(),
        '/biologia': (context) =>  const RecursosScreen(),
      },
    );
  }
}
