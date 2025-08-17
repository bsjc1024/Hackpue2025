import 'package:flutter/material.dart';

class RecursosScreen extends StatelessWidget {
  const RecursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Esto centra las lecciones verticalmente
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // evita que ocupe todo el espacio
                  crossAxisAlignment: CrossAxisAlignment.center, // centra horizontalmente
                  children: [
                    // Título
                    const Text(
                      "Recursos",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50), // azul oscuro / gris de la paleta
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lecciones como cajas
                    _buildLessonBox("Lección 1"),
                    _buildLessonBox("Lección 2"),
                    _buildLessonBox("Lección 3"),
                    _buildLessonBox("Lección 4"),
                    _buildLessonBox("Lección 5"),
                  ],
                ),
              ),
            ),

            // Botón siguiente en la parte inferior
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/siguiente");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB), // azul brillante
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Siguiente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para las cajas de lecciones
  Widget _buildLessonBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECF0F1), // gris claro
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDC3C7)), // borde suave
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
          color: Color(0xFF2C3E50), // gris oscuro
        ),
      ),
    );
  }
}