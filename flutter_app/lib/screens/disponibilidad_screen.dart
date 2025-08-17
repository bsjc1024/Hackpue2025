import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/questions_provider.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({super.key});
  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  final TextEditingController mesesController = TextEditingController();
  final TextEditingController diasController = TextEditingController();
  final TextEditingController horasController = TextEditingController();
  final TextEditingController carreraController = TextEditingController();
  final TextEditingController universidadController = TextEditingController();

  void _saveDataAndProceed() {
    final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
    
    // Save all the data to the provider
    questionsProvider.updateFormData(
      carrera: carreraSeleccionada ?? '',
      universidad: universidadSeleccionada ?? '',
      meses: int.tryParse(mesesController.text) ?? 0,
      dias: int.tryParse(diasController.text) ?? 0,
      horas: int.tryParse(horasController.text) ?? 0,
    );

    // Validate that all fields are filled
    if (!questionsProvider.isFormComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Por favor completa todos los campos correctamente.",
            style: GoogleFonts.openSans(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if study time is sufficient (optional validation)
    final totalHoras = questionsProvider.meses * 4 * questionsProvider.dias * questionsProvider.horas;
    
    if (totalHoras < 20) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0D47A1),
            title: Text(
              "Atención",
              style: GoogleFonts.righteous(
                fontSize: 22,
                color: const Color(0xFFFAD564),
              ),
            ),
            content: Text(
              "Recomendamos aumentar el número de semanas, días u horas para una mejor preparación.\n\nDisponibilidad total: $totalHoras horas",
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
    } else {
      // Navigate to the next screen (you'll need to implement this route)
      Navigator.pushNamed(context, '/exam_ubication');
    }
  }

  final List<String> carreras = [
    "Ingeniería en Sistemas",
    "Medicina",
    "Derecho",
    "Arquitectura",
    "Administración",
    "Diseño Gráfico"
  ];

  final List<String> universidades = [
    "UNAM",
    "IPN",
    "UAM",
    "BUAP",
    "ITESM",
    "UDLAP"
  ];

  String? carreraSeleccionada;
  String? universidadSeleccionada;

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
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF002B5B), // fondo azul
                value: carreraSeleccionada,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                ),
                hint: const Text(
                  "Selecciona una carrera",
                  style: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Color(0xFFFFF5D0)), // color del texto
                items: carreras.map((carrera) {
                  return DropdownMenuItem(
                  value: carrera,
                  child: Text(carrera, style: const TextStyle(color: Color(0xFFFFF5D0))),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    carreraSeleccionada = value;
                  });
                },
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
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF002B5B),
                value: universidadSeleccionada,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text(
                    "Selecciona una universidad",
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Color(0xFFFFF5D0)),
                  items: universidades.map((uni) {
                    return DropdownMenuItem(
                      value: uni,
                      child: Text(uni, style: const TextStyle(color: Color(0xFFFFF5D0))),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      universidadSeleccionada = value;
                    });
                  },
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
                onPressed: _saveDataAndProceed,
                child: Text(
                  "Continuar",
                  style: GoogleFonts.righteous(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Show current data preview (optional)
              Consumer<QuestionsProvider>(
                builder: (context, provider, child) {
                  if (provider.isFormComplete) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Resumen de tu información:",
                            style: GoogleFonts.righteous(
                              color: const Color(0xFFFAD564),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Carrera: ${provider.carrera}\nUniversidad: ${provider.universidad}\nTiempo: ${provider.meses} meses, ${provider.dias} días/semana, ${provider.horas} horas/día",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              color: const Color(0xFFFFF5D0),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
