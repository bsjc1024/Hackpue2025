import 'package:flutter/material.dart';

class ExamenEspanolScreen extends StatefulWidget {
  const ExamenEspanolScreen({super.key});

  @override
  State<ExamenEspanolScreen> createState() => _ExamenEspanolScreenState();
}

class _ExamenEspanolScreenState extends State<ExamenEspanolScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examen de Español"),
        backgroundColor: const Color(0xFF3498DB), // azul brillante
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Pregunta
            const Text(
              "¿Cuál de las siguientes oraciones está correctamente escrita?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Opciones
            _buildOptionButton("A. Me gusta ir al parque."),
            _buildOptionButton("B. Me gusta ir al parqué."),
            _buildOptionButton("C. Me gusta ir al park."),
            _buildOptionButton("D. Me gusta ir al parke."),
          ],
        ),
      ),
    );
  }

  // Widget para las opciones
  Widget _buildOptionButton(String text) {
    bool isSelected = selectedOption == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3498DB) : const Color(0xFFECF0F1), // azul si seleccionado
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBDC3C7)), // borde suave
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.white : const Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
