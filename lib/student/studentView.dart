import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';
import 'package:spring_ud4_grupo1_app/services/studentService.dart';
import 'package:spring_ud4_grupo1_app/student/studentCards.dart';

class StudentView extends StatefulWidget {
  final String token;

  StudentView({Key? key, required this.token}) : super(key: key);

  @override
  _StudentViewState createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  late StudentService _studentService;

  @override
  void initState() {
    super.initState();
    _studentService = StudentService();
  }

void _viewServices() async {
  print('token'+widget.token);
  List<ServicioModel>? services = await _studentService.viewServices(widget.token);
  
  if (services != null) {
    for (var service in services) {
      print('ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
    }
  _navigateToServicioListScreen(services);
  } else {
    _showError();
  }
}

void _viewAssignedServices() async {
  List<ServicioModel>? services = await _studentService.viewAssignedServices(widget.token);
  if (services != null) {
    for (var service in services) {
      print('ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
    }
  _navigateToServicioListScreen(services);
  } else {
    _showError();
  }
}

void _viewUnassignedServices() async {
  List<ServicioModel>? services = await _studentService.viewUnassignedServices(widget.token);
  if (services != null) {
    for (var service in services) {
      print('ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
    }
  _navigateToServicioListScreen(services);
  } else {
    _showError();
  }
}

void _navigateToServicioListScreen(List<ServicioModel> servicios) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ServicioListScreen(servicios: servicios)),
  );
}

void _showError() {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Error al recuperar los servicios')),
  );
}

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
                    'Retrieve all services related to their professional family.',
                    () => _viewServices()),
                _buildButtonWithIconAndText(
                    Icons.group_work,
                    'Retrieve all services related to their professional family, that are assigned to them.',
                    () => _viewAssignedServices()),
                _buildButtonWithIconAndText(
                    Icons.group_add,
                    'Retrieve all services related to their professional family, that are not assigned to any student.',
                    () => _viewUnassignedServices()),
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
          icon: Icon(icon, size: 50, color: Colors.white),
          onPressed: onPressed,
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    ),
  );
}
}
