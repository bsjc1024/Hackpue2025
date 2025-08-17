import 'package:flutter/material.dart';
//import 'screen/login_screen.dart'; 
//import 'screen/register.dart';
//import 'screen/university_question_screen.dart';
import 'screen/exam_question_screen.dart';

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
      home: const ExamQuestionScreen(),
      //routes: {
        //'/login': (context) => const LoginScreen(),
        //'/register': (context) => const RegisterScreen(),
        //'/university_question': (context) => const UniversityQuestionScreen(),
      //},
    );
  }
}
