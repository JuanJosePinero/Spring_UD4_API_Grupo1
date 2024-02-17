import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/businessService.dart';

class BusinessView extends StatefulWidget {
  final String token;

  BusinessView({Key? key, required this.token}) : super(key: key);

  @override
  _BusinessViewState createState() => _BusinessViewState();
}

class _BusinessViewState extends State<BusinessView> {
  late BusinessService _businessService;

  @override
  void initState() {
    super.initState();
    _businessService = BusinessService();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Page'),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButtonWithIconAndText(
                      Icons.add,
                      'Crear nuevo servicio por parte de la empresa logueada',
                      () => {}),
                  _buildButtonWithIconAndText(
                      Icons.search,
                      'Recuperar un determinado servicio de la empresa logueada',
                      () => {}), 
                  _buildButtonWithIconAndText(
                      Icons.list,
                      'Recuperar todos los servicios de la empresa logueada',
                      () => {}), 
                  _buildButtonWithIconAndText(
                      Icons.edit,
                      'Actualizar un servicio de la empresa logueada',
                      () => {}), 
                  _buildButtonWithIconAndText(
                      Icons.delete,
                      'Eliminar un servicio de la empresa logueada',
                      () => {}), 
                  _buildButtonWithIconAndText(
                      Icons.filter_list,
                      'Recuperar los servicios de una empresa filtrando por familia profesional',
                      () => {}), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithIconAndText(IconData icon, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 30, color: Colors.white),
            onPressed: onPressed,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
