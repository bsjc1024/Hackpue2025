// lib/screens/login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final result = await UserService.loginUser(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result["user"] != null) {
      // Set user data in provider
      Provider.of<UserProvider>(context, listen: false).setUser(result['user']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bienvenido, ${result['user']['name']}")),
      );
      
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${result['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const Icon(
              Icons.login,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 40),
            
            // Campo de email
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 15),
            
            // Campo de contraseña
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 30),
            
            // Botón de login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : handleLogin,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Iniciar Sesión",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Enlace para registro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "¿No tienes cuenta? Regístrate",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}