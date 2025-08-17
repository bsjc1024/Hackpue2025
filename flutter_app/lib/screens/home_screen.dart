import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/gemini_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userEmail;

    if (userId == null) {
      setState(() {
        error = "Usuario no encontrado";
        isLoading = false;
      });
      return;
    }

    try {
      final result = await GeminiService.getUserProgress(userId);
      
      print("API Response: $result"); // Debug print
      
      if (result['error'] != null) {
        setState(() {
          error = result['error'];
          isLoading = false;
        });
      } else {
        setState(() {
          userData = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception in _loadUserProgress: $e"); // Debug print
      setState(() {
        error = "Error al cargar datos: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    await _loadUserProgress();
  }

  // Navigate to subject detail screen
  Future<void> _navigateToSubject(String subject) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: Color(0xFF1B475D),
            content: Row(
              children: [
                CircularProgressIndicator(color: Color(0xFF8EBD9D)),
                SizedBox(width: 20),
                Text(
                  "Cargando recursos...",
                  style: TextStyle(color: Color(0xFFFFF5D0)),
                ),
              ],
            ),
          );
        },
      );

      // Get detailed subject plan
      final result = await GeminiService.getSubjectPlan(
        userProvider.userEmail!, 
        subject
      );

      Navigator.pop(context); // Close loading dialog

      if (result['success'] == true && result['studyPlan'] != null) {
        // Navigate to resources screen with subject data
        Navigator.pushNamed(
          context,
          '/recursos',
          arguments: {
            'subject': subject,
            'studyPlan': result['studyPlan'],
            'userName': userProvider.userName,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al cargar plan de $subject: ${result['error'] ?? 'Error desconocido'}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if it's open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de conexión: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8EBD9D),
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error!,
                style: const TextStyle(
                  color: Color(0xFFFFF5D0),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                ),
                onPressed: _refreshData,
                child: const Text(
                  "Reintentar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/disponibilidad');
                },
                child: const Text(
                  "Crear nuevo plan de estudio",
                  style: TextStyle(color: Color(0xFFFAD564)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Handle case where userData exists but doesn't have subjects or studyRoutes
    if (userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No se encontraron datos del usuario",
                style: TextStyle(
                  color: Color(0xFFFFF5D0),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/disponibilidad');
                },
                child: const Text(
                  "Crear plan de estudio",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Check if userData has subjects (new API format) or studyRoutes (old format)
    List<dynamic> studyRoutes = [];
    
    if (userData!.containsKey('subjects')) {
      // New API format
      studyRoutes = userData!['subjects'] as List<dynamic>? ?? [];
    } else if (userData!.containsKey('studyRoutes')) {
      // Old API format
      studyRoutes = userData!['studyRoutes'] as List<dynamic>? ?? [];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B475D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B475D),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Hola, ${userProvider.userName ?? 'Usuario'}",
          style: const TextStyle(
            color: Color(0xFFFAD564),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFFF5D0)),
            onPressed: () {
              userProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: studyRoutes.isEmpty
            ? _buildEmptyState()
            : _buildStudyRoutesList(studyRoutes),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: const Color(0xFF8EBD9D),
          ),
          const SizedBox(height: 20),
          const Text(
            "No tienes planes de estudio",
            style: TextStyle(
              color: Color(0xFFFFF5D0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Crea tu primer plan de estudio\npara comenzar a prepararte",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFF5D0),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8EBD9D),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/disponibilidad');
            },
            child: const Text(
              "Crear Plan de Estudio",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyRoutesList(List<dynamic> studyRoutes) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tus materias",
            style: TextStyle(
              color: Color(0xFFFFF5D0),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: studyRoutes.length,
              itemBuilder: (context, index) {
                final route = studyRoutes[index];
                return _buildStudyRouteCard(route);
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8EBD9D),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/disponibilidad');
              },
              child: const Text(
                "Crear Nuevo Plan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyRouteCard(Map<String, dynamic> route) {
    // Handle both new and old API formats
    final subject = route['subject'] ?? route['name'] ?? 'Materia';
    final progress = route['progressPercentage'] ?? route['progress'] ?? 0;
    final totalLessons = route['totalLessons'] ?? 0;
    final totalHours = route['totalHours'] ?? 0;
    final currentLevel = route['currentLevel'] ?? 'No especificado';

    Color cardColor;
    Color accentColor;
    IconData subjectIcon;

    switch (subject.toString().toLowerCase()) {
      case 'español':
        cardColor = Colors.blue.withOpacity(0.1);
        accentColor = Colors.blue;
        subjectIcon = Icons.edit_outlined;
        break;
      case 'biología':
        cardColor = Colors.green.withOpacity(0.1);
        accentColor = Colors.green;
        subjectIcon = Icons.biotech_outlined;
        break;
      default:
        cardColor = Colors.grey.withOpacity(0.1);
        accentColor = Colors.grey;
        subjectIcon = Icons.book_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A5F7A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to subject resources
          _navigateToSubject(subject.toString().toLowerCase());
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    subjectIcon,
                    color: accentColor,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.toString().toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFFAD564),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Nivel: $currentLevel",
                          style: const TextStyle(
                            color: Color(0xFFFFF5D0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "$progress%",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: progress / 100.0,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$totalLessons lecciones",
                    style: const TextStyle(
                      color: Color(0xFFFFF5D0),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "$totalHours horas",
                    style: const TextStyle(
                      color: Color(0xFFFFF5D0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}