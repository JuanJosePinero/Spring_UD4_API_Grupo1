import 'package:flutter/material.dart';

class StudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Alumno'),
      ),
      body: Center(
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
    );
  }

  Widget _buildButtonWithIconAndText(IconData icon, String text) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Implementar la funcionalidad asociada a cada botón
          },
        ),
        SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
