import 'package:flutter/material.dart';

class BusinessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Empresa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtonWithIconAndText(
                Icons.add,
                'Crear nuevo servicio por parte de la empresa logueada'),
            _buildButtonWithIconAndText(
                Icons.search,
                'Recuperar un determinado servicio de la empresa logueada'),
            _buildButtonWithIconAndText(
                Icons.list,
                'Recuperar todos los servicios de la empresa logueada'),
            _buildButtonWithIconAndText(
                Icons.edit,
                'Actualizar un servicio de la empresa logueada'),
            _buildButtonWithIconAndText(
                Icons.delete,
                'Eliminar un servicio de la empresa logueada'),
            _buildButtonWithIconAndText(
                Icons.filter_list,
                'Recuperar los servicios de una empresa filtrando por familia profesional'),
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
