import 'package:flutter/material.dart';

class ResultadoScreen extends StatelessWidget {
  final List<Map<String, dynamic>> preguntas;
  final List<String?> respuestasUsuario;

  const ResultadoScreen({
    super.key,
    required this.preguntas,
    required this.respuestasUsuario,
  });

  @override
  Widget build(BuildContext context) {
    int correctas = 0;
    int incorrectas = 0;

    for (int i = 0; i < preguntas.length; i++) {
      if (respuestasUsuario[i] == preguntas[i]['respuestaCorrecta']) {
        correctas++;
      } else {
        incorrectas++;
      }
    }

    double porcentaje = (correctas / preguntas.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultados del Examen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "¡Examen terminado!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Preguntas correctas: $correctas",
              style: TextStyle(fontSize: 20, color: Colors.green[700]),
            ),
            Text(
              "Preguntas incorrectas: $incorrectas",
              style: TextStyle(fontSize: 20, color: Colors.red[700]),
            ),
            const SizedBox(height: 20),
            Text(
              "Calificación: ${porcentaje.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa al inicio o a otra pantalla
              },
              child: const Text("Regresar"),
            ),
          ],
        ),
      ),
    );
  }
}
