import 'package:flutter/material.dart';
import '../models/ServicioModel.dart';

class ServicioListScreen extends StatelessWidget {
  final List<ServicioModel> servicios;

  const ServicioListScreen({Key? key, required this.servicios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
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
        child: ListView.builder(
          itemCount: servicios.length,
          itemBuilder: (context, index) {
            final servicio = servicios[index];
            return Card(
              margin: const EdgeInsets.all(15.0),
              child: ListTile(
  title: Text(servicio.title ?? "No title"),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(servicio.description ?? "No description"),
      // Mostrar la valoración como estrellas
      Row(
        children: List.generate(5, (index) {
          return Icon(
            index < (servicio.valoration ?? 0).round() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      ),
    ],
  ),
  // Mover la fecha de registro al lugar de la valoración
  trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(_formatDate(servicio.registerDate)),
    ],
  ),
  isThreeLine: true,
),


            );
          },
        ),
      ),
    );
  }
  String _formatDate(DateTime? date) {
  if (date == null) return "No date";
  // Usa el paquete intl para formatear fechas, o construye el formato manualmente
  return "${date.day}-${date.month}-${date.year}";
}

}