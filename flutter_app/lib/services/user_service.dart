import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://localhost:3000/users";

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.body.isEmpty) {
        return {"message": "No response from server"};
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {"message": "Connection error: ${e.toString()}"};
    }
  }
}
