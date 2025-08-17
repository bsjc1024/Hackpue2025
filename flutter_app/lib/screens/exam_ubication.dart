import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questions_provider.dart';
import '../providers/user_provider.dart';
import '../services/gemini_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestionsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Examen de Prueba',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ExamenView(),
        routes: {
          '/home': (context) => const HomeScreen(), // Add your home screen here
        },
      ),
    );
  }
}

// Placeholder for HomeScreen - replace with your actual home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}

// ---------------- EXAMEN ----------------
class ExamenView extends StatefulWidget {
  const ExamenView({super.key});

  @override
  State<ExamenView> createState() => _ExamenViewState();
}

class _ExamenViewState extends State<ExamenView> {
  int _preguntaActual = 0;

  final List<Map<String, dynamic>> _preguntas = [
    {
      "pregunta": "En la fotosíntesis se rompe una molécula de H2O para producir inicialmente:",
      "opciones": ["Monóxido de carbono", "Oxígeno", "Glucosa", "Dióxido de carbono"],
      "respuestaCorrecta": "Oxígeno"
    },
    {
      "pregunta": "¿Qué sucede en la interfase y la mitosis?",
      "opciones": [
        "Interfase: G, S, P Mitosis: G1, S, G2",
        "Interfase: P, G1, G2 Mitosis: P, M, S, T",
        "Interfase: G1, S, G2 Mitosis: P, M, A, T",
        "Interfase: G1, S, M Mitosis: P, M, A"
      ],
      "respuestaCorrecta": "Interfase: G1, S, G2 Mitosis: P, M, A, T"
    },
    {
      "pregunta": "¿Qué favorece la reproducción sexual?",
      "opciones": [
        "Variabilidad genética",
        "Formación de células diploides",
        "Descendientes idénticos",
        "Numerosos descendientes"
      ],
      "respuestaCorrecta": "Variabilidad genética"
    },
    {
      "pregunta": "Si observas una célula y se distingue el corpúsculo de Barr ¿A qué tipo de célula pertenece?",
      "opciones": [
        "Individuo masculino.",
        "Cromosomas",
        "Cromosoma masculino",
        "Individuo femenino"
      ],
      "respuestaCorrecta": "Individuo femenino"
    },
    {
      "pregunta": "El metabolismo es la prueba de que la célula es la unidad:",
      "opciones": [
        "Anatómica y genética",
        "Anatómica y funciona",
        "Genética y funcional",
        "Pequeña e indivisible"
      ],
      "respuestaCorrecta": "Anatómica y funciona"
    },
    {
      "pregunta": "Cuando te duelen los músculos ¿Qué se produjo?",
      "opciones": [
        "Malato",
        "Lactato",
        "Etano",
        "Piruvato"
      ],
      "respuestaCorrecta": "Lactato" 
    },
    {
      "pregunta": "Los borrados para realizar la Judea utilizan?",
      "opciones": [
        "olote, varas de otate, sables de madera y cúpula",
        "olote, varas de otate, sables de madera y máscaras.",
        "tocados, olote, varas de otate, máscaras y sables de madera",
        "varas de otate, olote, sables de madera y peyote"
      ],
      "respuestaCorrecta": "varas de otate, olote, sables de madera y peyote."
    },
    {
      "pregunta": "Al ser capturado el niño los demonios se autodestruyen puesto que",
      "opciones": [
        "deben acabarse entre ellos mismo",
        "quieren dominar a los pobladores",
        "no hay un orden superior que los controle",
        "representan las fuerzas del inframundo"
      ],
      "respuestaCorrecta": "no hay un orden superior que los controle."
    },
    {
      "pregunta": "Hay un SUJETO TÁCITO O IMPLÍCITO en",
      "opciones": [
        "Somos nada frente a la muerte infausta",
        "Feliz aquél que busca a Dios en sí mismo",
        "¡Señor!, tiembla mi alma ante tu grandeza",
        "Yo he subido más alto, mucho más alto"
      ],
      "respuestaCorrecta": "Somos nada frente a la muerte infausta"
    },
    {
      "pregunta": "Elige la opción que contiene sujeto y predicado",
      "opciones": [
        "Es útil la computadora",
        "Las pirámides de Teotihuacán",
        "Hoy, mañana y siempre",
        "Las cuentas del gran capitán"
      ],
      "respuestaCorrecta": "Es útil la computadora"
    },
    {
      "pregunta": "Existe un error de concordancia en:",
      "opciones": [
        "Los checoslovacos combatían en las calles y se oponían a la dictadura",
        "Un sinnúmero de feligreses acudió a la Villa",
        "La creación de muchas cosas no se tenían contempladas",
        "El constante flujo y reflujo de divisas provocó alarma."
      ],
      "respuestaCorrecta": "La creación de muchas cosas no se tenían contempladas"
    },
    {
      "pregunta": "Elige la función de la lengua que predomina en el siguiente ejemplo. Luisa, ¿puedes limpiar la mesa y lavar los trastes por favor?",
      "opciones": [
        "Metalingüística",
        "Apelativa",
        "Referencial",
        "Sintomática"
      ],
      "respuestaCorrecta": "Apelativa"
    }
  ];

  // Lista para guardar las respuestas del usuario
  List<String?> _respuestasUsuario = [];

  // Respuesta seleccionada en la pregunta actual
  String? _respuestaSeleccionada;

  @override
  void initState() {
    super.initState();
    _respuestasUsuario = List.filled(_preguntas.length, null);
  }

  void _siguientePregunta() {
    // Guardar la respuesta actual
    _respuestasUsuario[_preguntaActual] = _respuestaSeleccionada;

    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
        _respuestaSeleccionada = _respuestasUsuario[_preguntaActual];
      });
    } else {
      // Terminar examen y mostrar resultados
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultadoScreen(
            preguntas: _preguntas,
            respuestasUsuario: _respuestasUsuario,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = _preguntas[_preguntaActual];

    return Scaffold(
      backgroundColor: const Color(0xFF1B475D), // Fondo de toda la vista
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B475D), // Fondo igual al body
        elevation: 0, // Quita sombra
        centerTitle: true, // Centrar título
        title: Text(
          "Examen de ubicación",
          style: GoogleFonts.righteous(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 188, 201, 69),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pregunta ${_preguntaActual + 1}/${_preguntas.length}",
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 247, 239, 209),
              ),
            ),
            const SizedBox(height: 20),

            // Texto de la pregunta
            Text(
              pregunta["pregunta"],
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 247, 239, 209),
              ),
            ),
            const SizedBox(height: 20),

            // Lista de opciones
            ...pregunta["opciones"].map<Widget>((opcion) {
              return RadioListTile<String>(
                activeColor: const Color(0xFFB4BD62), // color del radio
                title: Text(
                  opcion,
                  style: GoogleFonts.openSans(
                    fontSize: 18, // un poco más pequeño que la pregunta
                    color: const Color.fromARGB(255, 247, 239, 209),
                  ),
                ),
                value: opcion,
                groupValue: _respuestaSeleccionada,
                onChanged: (value) {
                  setState(() {
                    _respuestaSeleccionada = value;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 20),

            // Botón de siguiente
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D), // color botón 
                  foregroundColor: const Color(0xFF1B475D), // color texto
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _respuestaSeleccionada == null ? null : _siguientePregunta,
                child: Text(
                  _preguntaActual == _preguntas.length - 1 ? "Finalizar" : "Siguiente",
                  style: GoogleFonts.righteous(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- RESULTADOS ----------------
class ResultadoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> preguntas;
  final List<String?> respuestasUsuario;

  const ResultadoScreen({
    super.key,
    required this.preguntas,
    required this.respuestasUsuario,
  });

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  bool _isGeneratingPlan = false;

  Future<void> _generateStudyPlan() async {
    setState(() {
      _isGeneratingPlan = true;
    });

    try {
      final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Verificar que tenemos todos los datos necesarios
      if (!questionsProvider.isCompleteForAPI) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Faltan datos del perfil para generar el plan de estudio"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isGeneratingPlan = false;
        });
        return;
      }

      if (userProvider.userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuario no identificado. Por favor inicia sesión nuevamente."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isGeneratingPlan = false;
        });
        return;
      }

      final result = await GeminiService.generateStudyPlan(
        carrera: questionsProvider.carrera,
        universidad: questionsProvider.universidad,
        nivelEspanol: questionsProvider.nivelEspanol,
        nivelBiologia: questionsProvider.nivelBiologia,
        dias: questionsProvider.dias,
        horas: questionsProvider.horas,
        meses: questionsProvider.meses,
        userId: userProvider.userId!,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Plan de estudio generado exitosamente'),
            backgroundColor: const Color(0xFF8EBD9D),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navegar al home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${result['error'] ?? 'Error desconocido'}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de conexión: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    setState(() {
      _isGeneratingPlan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int correctasBiologia = 0;
    int incorrectasBiologia = 0;
    int correctasEspanol = 0;
    int incorrectasEspanol = 0;

    // Recorremos preguntas
    for (int i = 0; i < widget.preguntas.length; i++) {
      bool esCorrecta = widget.respuestasUsuario[i] == widget.preguntas[i]['respuestaCorrecta'];

      if (i < 6) {
        // Preguntas 0 a 5 → Biología
        if (esCorrecta) {
          correctasBiologia++;
        } else {
          incorrectasBiologia++;
        }
      } else {
        // Preguntas 6 a 11 → Español
        if (esCorrecta) {
          correctasEspanol++;
        } else {
          incorrectasEspanol++;
        }
      }
    }

    // Calificación por materia
    double porcentajeBiologia = (correctasBiologia / 6) * 100;
    double porcentajeEspanol = (correctasEspanol / 6) * 100;

    // Actualizar los niveles en el provider
    final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
    questionsProvider.setSkillLevelsFromExam(porcentajeEspanol, porcentajeBiologia);

    return Scaffold(
      backgroundColor: const Color(0xFF1B475D),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "¡Examen terminado!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.righteous(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFAD564),
                  ),
                ),
                const SizedBox(height: 30),

                // ---------- BIOLOGÍA ----------
                Text(
                  "Biología",
                  style: GoogleFonts.righteous(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8EBD9D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Correctas: $correctasBiologia",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: const Color(0xFFFFF5D0),
                  ),
                ),
                Text(
                  "Incorrectas: $incorrectasBiologia",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: const Color(0xFFFFF5D0),
                  ),
                ),
                Text(
                  "Calificación: ${porcentajeBiologia.toStringAsFixed(1)}%",
                  style: GoogleFonts.righteous(
                    fontSize: 22,
                    color: const Color(0xFFFAD564),
                  ),
                ),

                const SizedBox(height: 40),

                // ---------- ESPAÑOL ----------
                Text(
                  "Español",
                  style: GoogleFonts.righteous(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8EBD9D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Correctas: $correctasEspanol",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: const Color(0xFFFFF5D0),
                  ),
                ),
                Text(
                  "Incorrectas: $incorrectasEspanol",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: const Color(0xFFFFF5D0),
                  ),
                ),
                Text(
                  "Calificación: ${porcentajeEspanol.toStringAsFixed(1)}%",
                  style: GoogleFonts.righteous(
                    fontSize: 22,
                    color: const Color(0xFFFAD564),
                  ),
                ),

                const SizedBox(height: 50),

                // Botones de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EBD9D),
                      foregroundColor: const Color(0xFF1B475D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isGeneratingPlan ? null : _generateStudyPlan,
                    child: _isGeneratingPlan
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1B475D),
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Generando plan...",
                                style: GoogleFonts.righteous(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "Generar Plan de Estudio",
                            style: GoogleFonts.righteous(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón alternativo para ir directamente al home
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8EBD9D)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Ir al Inicio",
                      style: GoogleFonts.righteous(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8EBD9D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}