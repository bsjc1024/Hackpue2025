import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmarCtrl = TextEditingController();

  Future<void> handleRegister() async {
    if (passwordCtrl.text != confirmarCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    final result = await UserService.registerUser(
      name: nameCtrl.text,
      email: emailCtrl.text,
      password: passwordCtrl.text,
    );

    if (!mounted) return;

    if (result["user"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado: ${result['user']['name']}")),
      );
      Navigator.pop(context); // Regresa al login
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
        title: const Text("Registro"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "name completo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: confirmarCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirmar contraseña",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 30),

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
                  onPressed: handleRegister,
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "¿Ya tienes cuenta? Inicia sesión",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
