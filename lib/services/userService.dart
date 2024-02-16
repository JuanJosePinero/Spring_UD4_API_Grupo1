import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/StudentModel.dart';

class UserService {
  final String baseUrl = "https://ud4springgrupo1.onrender.com/api";

  static Future<List<ProFamilyModel>> getProFamilies() async {
    final response = await http.get(Uri.parse('tu_endpoint_para_profamilies'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ProFamilyModel> proFamilies = body.map((dynamic item) => ProFamilyModel.fromJson(item)).toList();
      return proFamilies;
    } else {
      throw Exception('Failed to load proFamilies');
    }
  }

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
      // Manejar el error o devolver null
      return null;
    }
  }
}
