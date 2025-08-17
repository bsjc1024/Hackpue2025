// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/disponibilidad_screen.dart';
import 'screens/exam_ubication.dart';
import 'providers/user_provider.dart';
import 'providers/questions_provider.dart';
import 'screens/home_screen.dart';
import 'services/gemini_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => QuestionsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hackpue Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLoggedIn 
                ? const InitialRouteChecker() 
                : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/disponibilidad': (context) => const DisponibilidadScreen(),
          '/exam_ubication': (context) => const ExamenView(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class InitialRouteChecker extends StatefulWidget {
  const InitialRouteChecker({super.key});

  @override
  State<InitialRouteChecker> createState() => _InitialRouteCheckerState();
}

class _InitialRouteCheckerState extends State<InitialRouteChecker> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkUserStudyPlans();
  }

  Future<void> _checkUserStudyPlans() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userEmail;

    if (userId == null) {
      // If no userId, go to login
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final result = await GeminiService.getUserProgress(userId);
      
      if (result['error'] != null) {
        // If there's an error or no study plans, go to disponibilidad
        Navigator.pushReplacementNamed(context, '/disponibilidad');
      } else {
        // Check if user has study plans
        List<dynamic> subjects = [];
        
        if (result.containsKey('subjects')) {
          subjects = result['subjects'] as List<dynamic>? ?? [];
        }
        
        if (subjects.isNotEmpty) {
          // User has study plans, go to home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // User has no study plans, go through the process
          Navigator.pushReplacementNamed(context, '/disponibilidad');
        }
      }
    } catch (e) {
      // On error, go to disponibilidad to create new plan
      Navigator.pushReplacementNamed(context, '/disponibilidad');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1B475D),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8EBD9D),
        ),
      ),
    );
  }
}