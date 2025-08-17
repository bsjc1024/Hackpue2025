import 'package:flutter/material.dart';

class ExamenBioScreen extends StatefulWidget {
  const ExamenBioScreen({super.key});

  @override
  State<ExamenBioScreen> createState() => _ExamenScreenState();
}

class _ExamenScreenState extends State<ExamenBioScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Pregunta
            const Text(
              "¿Cuál es la capital de Francia?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Opciones
            _buildOptionButton("A. Madrid"),
            _buildOptionButton("B. París"),
            _buildOptionButton("C. Berlín"),
            _buildOptionButton("D. Roma"),
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
          border: Border.all(color: const Color(0xFFBDC3C7)),
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
