import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Page'),
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
                      Icons.group,
                      'Alumnos: recuperan todos los servicios correspondientes a su familia profesional.'),
                  _buildButtonWithIconAndText(
                      Icons.group_work,
                      'Alumnos: recuperan todos los servicios correspondientes a su familia profesional, que tiene asignados.'),
                  _buildButtonWithIconAndText(
                      Icons.group_add,
                      'Alumnos: recuperan todos los servicios correspondientes a su familia profesional, que no tienen asignados ningún alumno.'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithIconAndText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), 
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 30, color: Colors.white), 
            onPressed: () {
              // Implementar la funcionalidad asociada a cada botón
            },
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white, 
            ),
          ),
        ],
      ),
    );
  }
}
