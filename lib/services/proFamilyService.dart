import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';

class ProFamilyService {
  final String baseUrl = "https://ud4springgrupo1.onrender.com";

  Future<List<ProFamilyModel>> getProfesionalFamilies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/proFamily/all'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      final List<ProFamilyModel> proFamilies =
          body.map((dynamic item) => ProFamilyModel.fromJson(item)).toList();
      return proFamilies;
    } else {
      print(
          'Failed to load professional families. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load professional families');
    }
  }
}
