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
    _showLoadingDialog(); // Mostrar el diálogo de carga
    try {
    print('token' + widget.token);
    List<ServicioModel>? services =
        await _studentService.viewServices(widget.token);
        Navigator.pop(
          context);

    if (services != null) {
      for (var service in services) {
        print(
            'ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
      }
      _navigateToServicioListScreen(services);
    } else {
      _showError();
    }
    } catch (e) {
      Navigator.pop(
          context); // Asegurarse de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error retrieving services")),
      );
    }
  }

  void _viewAssignedServices() async {
    _showLoadingDialog(); // Mostrar el diálogo de carga
    try {
      List<ServicioModel>? services =
          await _studentService.viewAssignedServices(widget.token);
          Navigator.pop(
          context);
      if (services != null) {
        for (var service in services) {
          print(
              'ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
        }
        _navigateToServicioListScreen(services);
      } else {
        _showError();
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegurarse de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error retrieving services")),
      );
    }
  }

  void _viewUnassignedServices() async {
    _showLoadingDialog(); // Mostrar el diálogo de carga
    try {
      List<ServicioModel>? services =
          await _studentService.viewUnassignedServices(widget.token);
          Navigator.pop(
          context);
      if (services != null) {
        for (var service in services) {
          print(
              'ID: ${service.id}, Título: ${service.title}, Descripción: ${service.description}');
        }
        _navigateToServicioListScreen(services);
      } else {
        _showError();
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegurarse de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error retrieving services")),
      );
    }
  }

  void _navigateToServicioListScreen(List<ServicioModel> servicios) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ServicioListScreen(servicios: servicios)),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error retrieving services")),
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

  Widget _buildButtonWithIconAndText(
      IconData icon, String text, VoidCallback onPressed) {
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

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
