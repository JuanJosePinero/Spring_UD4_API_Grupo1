import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BusinessService {
  final String baseUrl = "https://ud4springgrupo1.onrender.com/business";

  Future<List<ServicioModel>?> getBusinessServices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/servicios'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<ServicioModel> services =
          body.map((dynamic item) => ServicioModel.fromJson(item)).toList();
      return services;
    } else {
      return null;
    }
  }

  Future<ServicioModel> getBusinesSpecificService(
      String token, int serviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/servicios/$serviceId'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      ServicioModel service = ServicioModel.fromJson(body);
      return service;
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<List<ServicioModel>?> getBusinessProFamServices(
      String token, int proFamId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/servicios/proFam/$proFamId'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<ServicioModel> services =
          body.map((dynamic item) => ServicioModel.fromJson(item)).toList();
      return services;
    } else {
      return null;
    }
  }

  Future<ServicioModel> updateService(
      String token, int serviceId, ServicioModel serviceToUpdate) async {
    final response = await http.put(
      Uri.parse('$baseUrl/servicios/$serviceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: json.encode(serviceToUpdate.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      ServicioModel updatedService = ServicioModel.fromJson(body);
      return updatedService;
    } else {
      throw Exception(
          'Failed to update service. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteService(String token, int serviceId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/servicios/$serviceId'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 204) {
      print('Servicio eliminado exitosamente.');
    } else if (response.statusCode == 404) {
      throw Exception('Servicio no encontrado.');
    } else {
      throw Exception(
          'Error al eliminar el servicio. Status code: ${response.statusCode}');
    }
  }

  Future<ServicioModel> createService(
      String token, ServicioModel newService) async {
    final response = await http.post(
      Uri.parse('$baseUrl/newServicio'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: json.encode(newService.toJson()),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = json.decode(response.body);
      ServicioModel createdService = ServicioModel.fromJson(body);
      return createdService;
    } else if (response.statusCode == 400) {
      throw Exception(
          'Un servicio con el mismo título y descripción ya existe para esta empresa.');
    } else {
      throw Exception(
          'Error al crear el servicio. Status code: ${response.statusCode}');
    }
  }
}
