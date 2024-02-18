import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spring_ud4_grupo1_app/models/StudentModel.dart';

class UserService {
  final String baseUrl = "https://ud4springgrupo1.onrender.com/api";

  Future<StudentModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return StudentModel.fromJson(json.decode(response.body));
    } else {
      // Manejar el error o devolver null
      return null;
    }
  }

  Future<StudentModel?> register(StudentModel studentModel) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(studentModel.toJson()),
  );

  if (response.statusCode == 200) {
    return StudentModel.fromJson(json.decode(response.body));
  } else {
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
  final errorData = json.decode(response.body);
  throw Exception(errorData['message'] ?? 'Unknown error occurred');
}

}

}
