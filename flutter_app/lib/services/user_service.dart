import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://localhost:5000/users";

  static Future<Map<String, dynamic>> registerUser({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "email": correo,
        "password": contrasena,
      }),
    );

    return jsonDecode(response.body);
  }
}
