import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B475D), // Fondo de toda la vista
  appBar: AppBar(
    backgroundColor: const Color(0xFF1B475D), // Fondo igual al body
    elevation: 0, // Quita sombra
    centerTitle: true, // Centrar título
    title: Text(
      "Registro",
      style: GoogleFonts.righteous(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 188, 201, 69),
      ),
    ),
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
                color: Color.fromARGB(255, 188, 201, 69),
              ),
              const SizedBox(height: 40),

              // Nombre
              TextField(
                style: const TextStyle(color: Color(0xFFFFF5D0)), // 👈 Texto escrito
                decoration: InputDecoration(
                  labelText: "Nombre completo",
                  labelStyle: const TextStyle(color: Color(0xFFFFF5D0)), // 👈 Label blanco
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white), // 👈 Borde blanco
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF8EBD9D)), // 👈 Verde al enfocar
                  ),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFFFF5D0)),
                ),
              ),
              const SizedBox(height: 15),

              // Email
              TextField(
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Color(0xFFFFF5D0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF8EBD9D)),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFFFF5D0)),
                ),
              ),
              const SizedBox(height: 15),

              // Contraseña
              TextField(
                obscureText: true,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  labelStyle: const TextStyle(color: Color(0xFFFFF5D0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF8EBD9D)),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFF5D0)),
                ),
              ),
              const SizedBox(height: 15),

              // Confirmar contraseña
              TextField(
                obscureText: true,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                decoration: InputDecoration(
                  labelText: "Confirmar contraseña",
                  labelStyle: const TextStyle(color: Color(0xFFFFF5D0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF8EBD9D)),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFFF5D0)),
                ),
              ),
              const SizedBox(height: 30),

              // Botón
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EBD9D),
                    foregroundColor: const Color(0xFF1B475D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cuenta creada con éxito")),
                    );
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  style: TextStyle(color: Color(0xFF8EBD9D), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
