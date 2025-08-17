import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({super.key});
  @override
  _DisponibilidadScreenState createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  final TextEditingController mesesController = TextEditingController();
  final TextEditingController diasController = TextEditingController();
  final TextEditingController horasController = TextEditingController();
  final TextEditingController carreraController = TextEditingController();
  final TextEditingController universidadController = TextEditingController();


  String resultado = "";

  void calcularDisponibilidad() {
    final meses = int.tryParse(mesesController.text) ?? 0;
    final dias = int.tryParse(diasController.text) ?? 0;
    final horas = int.tryParse(horasController.text) ?? 0;

    setState(() {
      if (meses > 0 && dias > 0 && horas > 0) {
        final totalHoras = meses * 4 * dias * horas;
        resultado =
            "Disponibilidad total: $totalHoras horas";

        if (totalHoras < 20) {
          // Mostrar alerta
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF0D47A1), // mismo azul de fondo
                title: Text(
                  "Atención",
                  style: GoogleFonts.righteous(
                    fontSize: 22,
                    color: const Color(0xFFFAD564),
                  ),
                ),
                content: Text(
                  "Recomendamos aumentar el número de semanas, días u horas para una mejor preparación.",
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: const Color(0xFFFFF5D0),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Entendido",
                      style: GoogleFonts.righteous(
                        color: const Color(0xFF8EBD9D),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
      } else {
        resultado = "Por favor completa todos los campos correctamente.";
      }
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B5B), // azul fuerte
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF002B5B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Disponibilidad de estudio",
          style: GoogleFonts.righteous(
            color: const Color(0xFFb4bd62),
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "¿En cuantos meses presentarás el examen?",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: const Color(0xFFfff5d0),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: mesesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Ejemplo: 4",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color.fromARGB(26, 225, 215, 215),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "¿Cuántos días a la semana puedes estudiar?",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: const Color(0xFFfff5d0),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diasController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Ejemplo: 5",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "¿Cuántas horas al día?",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: const Color(0xFFfff5d0),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: horasController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Ejemplo: 3",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Text(
                "¿Qué carrera deseas estudiar?",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                color: Color(0xFFFFF5D0),
                fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: carreraController,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Ejemplo: Medicina",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "¿En qué universidad quieres ingresar?",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                color: Color(0xFFFFF5D0),
                fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: universidadController,
                style: const TextStyle(color: Color(0xFFFFF5D0)),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Ejemplo: UNAM",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8ebd9d),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: calcularDisponibilidad,
                child: Text(
                  "Calcular",
                  style: GoogleFonts.righteous(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (resultado.isNotEmpty)
                Text(
                  resultado,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFfad564),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
