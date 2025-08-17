//gemini service flutter
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String baseUrl = "http://localhost:3000/gemini";

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
}