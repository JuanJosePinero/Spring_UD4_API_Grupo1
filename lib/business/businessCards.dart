import 'package:flutter/material.dart';
import '../models/ServicioModel.dart';

class BusinessCards extends StatelessWidget {
  final List<ServicioModel> servicios;

  const BusinessCards({Key? key, required this.servicios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de la Empresa'),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue.shade100, Colors.blue.shade300],
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
                subtitle: Text(servicio.description ?? "No description"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_formatDate(servicio.registerDate)),
                    // Aquí agregarías los demás atributos como se requiera
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
    return "${date.day}-${date.month}-${date.year}";
  }
}
