import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';

class StudentService {
  final String baseUrl = "https://ud4springgrupo1.onrender.com/student";

  Future<List<ServicioModel>?> viewServices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewServices'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<ServicioModel> services = body.map((dynamic item) => ServicioModel.fromJson(item)).toList();
      return services;
    } else {
      return null;
    }
  }

  Future<List<ServicioModel>?> viewAssignedServices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewServicesAssigned'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<ServicioModel> assignedServices = body.map((dynamic item) => ServicioModel.fromJson(item)).toList();
      return assignedServices;
    } else {
      return null;
    }
  }

  Future<List<ServicioModel>?> viewUnassignedServices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/viewServicesUnassigned'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<ServicioModel> unassignedServices = body.map((dynamic item) => ServicioModel.fromJson(item)).toList();
      return unassignedServices;
    } else {
      return null;
    }
  }
}