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
                backgroundColor: const Color(0xFFE4572E), // mismo azul de fondo
                title: Text(
                  "Atención",
                  style: GoogleFonts.freeman(
                    fontSize: 22,
                    color: const Color(0xFF2E282A),
                  ),
                ),
                content: Text(
                  "Recomendamos aumentar el número de semanas, días u horas para una mejor preparación.",
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: const Color(0xFF2E282A),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Entendido",
                      style: GoogleFonts.freeman(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // azul fuerte
      
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Disponibilidad de estudio",
                textAlign: TextAlign.center,
                style: GoogleFonts.freeman(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E282A),
                ),
              ),
              SizedBox(height: 20,),


              Text(
                "¿En cuantos meses presentarás el examen?",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  color: const Color(0xFF2E282A),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: mesesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFF2E282A)),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Ejemplo: 4",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(26, 225, 215, 215),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "¿Cuántos días a la semana puedes estudiar?",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  color: const Color(0xFF2E282A),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diasController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFF2E282A)),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Ejemplo: 5",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),      
                  ),
              ),
              const SizedBox(height: 24),
              Text(
                "¿Cuántas horas al día?",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  color: const Color(0xFF2E282A),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: horasController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFF2E282A)),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Ejemplo: 3",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Text(
                "¿Qué carrera deseas estudiar?",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                color: Color(0xFF2E282A),
                fontSize: 25,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF76B041), // fondo azul
                initialValue: carreraSeleccionada,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                ),
                hint: const Text(
                  "Selecciona una carrera",
                  style: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Color(0xFF2E282A)), // color del texto
                items: carreras.map((carrera) {
                  return DropdownMenuItem(
                  value: carrera,
                  child: Text(carrera, style: const TextStyle(color: Color(0xFF2E282A))),
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
                style: GoogleFonts.robotoCondensed(
                color: Color(0xFF2E282A),
                fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF76B041),
                initialValue: universidadSeleccionada,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF76B041), width: 4),
                  ),
                  ),
                  hint: const Text(
                    "Selecciona una universidad",
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Color(0xFF2E282A)),
                  items: universidades.map((uni) {
                    return DropdownMenuItem(
                      value: uni,
                      child: Text(uni, style: const TextStyle(color: Color(0xFF2E282A))),
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
                  backgroundColor: const Color(0xFFFFC914),
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
                Column(
                  children: [
                    Text(
                      resultado,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFfad564),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF17BEBB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/exam');
                      },
                      child: Text(
                        "Tomar la prueba",
                        style: GoogleFonts.freeman(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      )),
      );
    }
  }