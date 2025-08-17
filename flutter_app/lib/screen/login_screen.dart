import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tituloColor = Color(0xFF2E282A); // mismo color para botón y texto

    return Scaffold(
      backgroundColor: Color(0xFFE4572E),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            Text(
              "Tu meta te espera",
              textAlign: TextAlign.center,
              style: GoogleFonts.freeman(
                fontSize: 50, // más grande
                fontWeight: FontWeight.bold,
                color: tituloColor,
              ),
            ),
            const SizedBox(height: 60), // espacio arriba y abajo del título

            // Campo de email
            TextField(
              style: const TextStyle(fontSize: 20, color: Colors.black), // letra blanca
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontSize: 20, color: tituloColor),
                filled: true,
                fillColor: Colors.white, // fondo blanco
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tituloColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de contraseña
            TextField(
              obscureText: true,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                labelText: "Contraseña",
                labelStyle: TextStyle(fontSize: 20, color: tituloColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tituloColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Botón de login
            SizedBox(
              width: double.infinity,
              height: 60, // más grande
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF17BEBB), // mismo color que el título
                  foregroundColor: Color(0xFF2E282A), // letra blanca
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/disponibilidad');
                },
                child: Text(
                  "Iniciar Sesión",
                  style: GoogleFonts.freeman(
                    fontSize: 24, // más grande
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Enlace para registro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "\n¿No tienes cuenta? \n Regístrate", // salto de línea arriba
                textAlign: TextAlign.center,
                style: GoogleFonts.freeman(
                  fontSize: 22, // más grande
                  fontWeight: FontWeight.bold,
                  color: tituloColor, // mismo color que el título
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
