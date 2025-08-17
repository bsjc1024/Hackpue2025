import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecursosScreen extends StatefulWidget {
  const RecursosScreen({super.key});

  @override
  State<RecursosScreen> createState() => _RecursosScreenState();
}

class _RecursosScreenState extends State<RecursosScreen> {
  Map<String, dynamic>? studyPlan;
  String? subject;
  String? userName;
  int currentLessonIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments passed from previous screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      studyPlan = args['studyPlan'];
      subject = args['subject'];
      userName = args['userName'];
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url == 'Buscar en biblioteca' || url == 'Buscar en biblioteca científica') {
      // Show a message for placeholder URLs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Busca este recurso en tu biblioteca local o en línea"),
          backgroundColor: Color(0xFF8EBD9D),
        ),
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir el enlace');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al abrir el enlace: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getSubjectColor() {
    switch (subject?.toLowerCase()) {
      case 'español':
        return Colors.blue;
      case 'biología':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getResourceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle_outline;
      case 'documento':
      case 'libro':
        return Icons.description_outlined;
      case 'ejercicios':
        return Icons.quiz_outlined;
      case 'simulador':
        return Icons.science_outlined;
      case 'experimento':
        return Icons.biotech_outlined;
      default:
        return Icons.link_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (studyPlan == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        body: const Center(
          child: Text(
            "No se pudieron cargar los recursos",
            style: TextStyle(color: Color(0xFFFFF5D0), fontSize: 18),
          ),
        ),
      );
    }

    final lessons = studyPlan!['lessons'] as List<dynamic>? ?? [];
    final subjectColor = _getSubjectColor();
    final subjectTitle = (subject ?? 'Materia').toUpperCase();

    if (lessons.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B475D),
          elevation: 0,
          title: Text(
            "Recursos - $subjectTitle",
            style: const TextStyle(
              color: Color(0xFFFAD564),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFFF5D0)),
        ),
        body: const Center(
          child: Text(
            "No hay lecciones disponibles",
            style: TextStyle(color: Color(0xFFFFF5D0), fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B475D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B475D),
        elevation: 0,
        title: Text(
          "Recursos - $subjectTitle",
          style: const TextStyle(
            color: Color(0xFFFAD564),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFF5D0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Subject info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: subjectColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: subjectColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    studyPlan!['name'] ?? 'Plan de Estudio',
                    style: TextStyle(
                      color: subjectColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nivel: ${studyPlan!['currentLevel'] ?? 'No especificado'}",
                    style: const TextStyle(
                      color: Color(0xFFFFF5D0),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Total: ${studyPlan!['totalHours'] ?? 0} horas",
                    style: const TextStyle(
                      color: Color(0xFFFFF5D0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Lessons list title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Lecciones",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFF5D0),
                  ),
                ),
                Text(
                  "${lessons.length} lecciones",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFF5D0),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),

            // Lessons list
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _buildLessonCard(lesson, index, subjectColor);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Back button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Volver al Inicio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson, int index, Color accentColor) {
    final title = lesson['title'] ?? 'Lección ${index + 1}';
    final description = lesson['description'] ?? 'Sin descripción';
    final estimatedHours = lesson['estimatedHours'] ?? 0;
    final resources = lesson['resources'] as List<dynamic>? ?? [];
    final isCompleted = lesson['completed'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A5F7A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted ? accentColor : accentColor.withOpacity(0.3),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: isCompleted ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFAD564),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFFFFF5D0),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "$estimatedHours horas • ${resources.length} recursos",
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        iconColor: const Color(0xFFFFF5D0),
        collapsedIconColor: const Color(0xFFFFF5D0),
        children: [
          if (resources.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No hay recursos disponibles para esta lección",
                style: TextStyle(
                  color: Color(0xFFFFF5D0),
                  fontSize: 14,
                ),
              ),
            )
          else
            ...resources.map<Widget>((resource) {
              return _buildResourceItem(resource, accentColor);
            }).toList(),
          
          // Complete lesson button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCompleted ? null : () {
                  // TODO: Implement lesson completion logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lección ${index + 1} marcada como completada"),
                      backgroundColor: accentColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey : accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isCompleted ? "Lección Completada" : "Marcar como Completada",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource, Color accentColor) {
    final title = resource['title'] ?? 'Recurso sin título';
    final url = resource['url'] ?? '';
    final type = resource['type'] ?? 'documento';
    
    return ListTile(
      leading: Icon(
        _getResourceIcon(type),
        color: accentColor,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFF5D0),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: accentColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: url.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.open_in_new,
                color: Color(0xFF8EBD9D),
                size: 20,
              ),
              onPressed: () => _launchUrl(url),
            )
          : null,
      onTap: url.isNotEmpty ? () => _launchUrl(url) : null,
    );
  }
}