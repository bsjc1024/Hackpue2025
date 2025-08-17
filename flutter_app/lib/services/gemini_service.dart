import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String baseUrl = "http://localhost:3000/gemini";

  // Generar ambos planes de estudio (español y biología)
  static Future<Map<String, dynamic>> generateStudyPlan({
    required String carrera,
    required String universidad,
    required String nivelEspanol,
    required String nivelBiologia,
    required int dias,
    required int horas,
    required int meses,
    required String userId,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/generate-plan");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "carrera": carrera,
          "universidad": universidad,
          "nivel_español": nivelEspanol,
          "nivel_biologia": nivelBiologia,
          "dias": dias,
          "horas": horas,
          "meses": meses,
          "userId": userId,
        }),
      );

      if (response.body.isEmpty) {
        return {"error": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"error": "Connection error: ${e.toString()}"};
    }
  }

  // Obtener progreso general del usuario
  static Future<Map<String, dynamic>> getUserProgress(String userId) async {
    try {
      final url = Uri.parse("$baseUrl/progress/$userId");

      final response = await http.get(url);

      if (response.body.isEmpty) {
        return {"error": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"error": "Connection error: ${e.toString()}"};
    }
  }

  // Obtener progreso de una materia específica
  static Future<Map<String, dynamic>> getSubjectProgress(
    String userId, 
    String subject // 'español' o 'biología'
  ) async {
    try {
      final url = Uri.parse("$baseUrl/progress/$userId?subject=$subject");

      final response = await http.get(url);

      if (response.body.isEmpty) {
        return {"error": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"error": "Connection error: ${e.toString()}"};
    }
  }

  // Obtener plan de una materia específica
  static Future<Map<String, dynamic>> getSubjectPlan(
    String userId, 
    String subject // 'español' o 'biología'
  ) async {
    try {
      final url = Uri.parse("$baseUrl/subject/$userId/$subject");

      final response = await http.get(url);

      if (response.body.isEmpty) {
        return {"error": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"error": "Connection error: ${e.toString()}"};
    }
  }

  // Actualizar progreso de lección
  static Future<Map<String, dynamic>> updateLessonProgress({
    required String userId,
    required int lessonIndex,
    required String subject, // 'español' o 'biología'
  }) async {
    try {
      final url = Uri.parse("$baseUrl/progress/$userId");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lessonIndex": lessonIndex,
          "subject": subject,
        }),
      );

      if (response.body.isEmpty) {
        return {"error": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"error": "Connection error: ${e.toString()}"};
    }
  }
}
