// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spring_ud4_grupo1_app/business/businessCards.dart';
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';
import 'package:spring_ud4_grupo1_app/services/businessService.dart';
import 'package:spring_ud4_grupo1_app/services/proFamilyService.dart';

class BusinessView extends StatefulWidget {
  final String token;

  BusinessView({Key? key, required this.token}) : super(key: key);

  @override
  _BusinessViewState createState() => _BusinessViewState();
}

class _BusinessViewState extends State<BusinessView> {
  late BusinessService _businessService;
  late ProFamilyService _proFamilyService;
  List<ServicioModel> _services = [];
  List<ProFamilyModel> _profesionalFamilies = [];
  ProFamilyModel? _selectedProfesionalFamily;

  @override
  void initState() {
    super.initState();
    _businessService = BusinessService();
    _proFamilyService = ProFamilyService();
    _loadProFamilies();
  }

  Future<void> _loadProFamilies() async {
    final families =
        await _proFamilyService.getProfesionalFamilies('Bearer${widget.token}');
    setState(() {
      _profesionalFamilies = families;
    });
  }

  void _businessServices() async {
    _showLoadingDialog();
    try {
      final services = await _businessService.getBusinessServices(widget.token);
      Navigator.pop(context);
      if (services != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: services),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No se pudieron recuperar los servicios")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _businessSpecificServices(int serviceId) async {
    try {
      final service = await _businessService.getBusinessSpecificService(
          widget.token, serviceId);
      if (service != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: [service]),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo recuperar el servicio")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showSpecificServicesPanel() async {
    _showLoadingDialog();
    try {
      final services = await _businessService.getBusinessServices(widget.token);
      Navigator.pop(context);
      if (services != null) {
        showDialog(
          context: context,
          builder: (BuildContext localContext) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(localContext).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(services[index].title ?? "No title"),
                            onTap: () {
                              Navigator.of(context).pop();
                              _showSpecificServiceDetailsPanel(
                                  services[index].id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudieron cargar los servicios")),
        );
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegurarse de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error retrieving services: $e")),
      );
    }
  }

  void _showSpecificServiceDetailsPanel(int? serviceId) async {
    _showLoadingDialog(); // Muestra el diálogo de carga al inicio
    try {
      if (serviceId == null) {
        Navigator.pop(
            context); // Cierra el diálogo de carga antes de mostrar el SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ID de servicio no válido")),
        );
        return;
      }

      final serviceDetails = await _businessService.getBusinessSpecificService(
          widget.token, serviceId);

      Navigator.pop(
          context); // Cierra el diálogo de carga justo antes de mostrar los detalles o el mensaje de error

      if (serviceDetails != null) {
        showDialog(
          context: context,
          builder: (BuildContext localContext) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Título: ${serviceDetails.title}"),
                    const SizedBox(height: 10),
                    Text("Descripción: ${serviceDetails.description}"),
                    const SizedBox(height: 10),
                    Text("Date: ${_formatDate(serviceDetails.registerDate)}")
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No se pudo cargar el detalle del servicio")),
        );
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegúrate de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error retrieving services: $e")),
      );
    }
  }

  void _showCreateServicePanel() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Mostrar un indicador de carga mientras se espera
        return FutureBuilder(
          future:
              Future.delayed(const Duration(seconds: 2)), // Espera 2 segundos
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return AlertDialog(
                title: const Text("Create New Service"),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          TextField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration:
                                const InputDecoration(labelText: 'Description'),
                          ),
                          DropdownButton<ProFamilyModel>(
                            value: _selectedProfesionalFamily,
                            hint: const Text("Select Professional Family"),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedProfesionalFamily = newValue;
                              });
                            },
                            items: _profesionalFamilies
                                .map((ProFamilyModel family) {
                              return DropdownMenuItem<ProFamilyModel>(
                                value: family,
                                child:
                                    Text(family.name ?? 'Nombre no disponible'),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Accept'),
                    onPressed: () async {
                      try {
                        final newService = ServicioModel(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          profesionalFamilyId: _selectedProfesionalFamily,
                        );
                        final createdService = await _businessService
                            .createService(widget.token, newService);
                        Navigator.pop(
                            context); // Cierra el diálogo después de la operación exitosa
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Service created successfully'),
                              ],
                            ),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(
                            context); // También cierra el diálogo si hay un error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _deleteServicesPanel() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext localContext) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(localContext).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(), // Indicador de carga
                  const SizedBox(
                      height:
                          20), // Espacio para separar el indicador del texto
                  const Text(
                      'Loading...'), // Texto para indicar que se está cargando
                ],
              ),
            ),
          );
        },
      );

      final services = await _businessService.getBusinessServices(widget.token);

      Navigator.pop(
          context); // Cerrar el diálogo de carga después de obtener la respuesta del servicio

      if (services != null) {
        final deleted = await showDialog<bool>(
          context: context,
          builder: (BuildContext localContext) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(localContext).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (services[index].id != null) {
                            return ListTile(
                              title: Text(services[index].title ?? "No title"),
                              onTap: () async {
                                final deleted = await _confirmDeleteService(
                                  services[index].id!,
                                  services[index].title,
                                  context,
                                );
                                if (deleted) {
                                  setState(() {
                                    // Remove the deleted service from the list
                                    services.removeAt(index);
                                  });
                                }
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(services[index].title ?? "No title"),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (deleted != null && deleted) {
          // Service was deleted, update the UI
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar familias profesionales: $e")),
        );
      }
    }
  }

  Future<bool> _confirmDeleteService(
      int serviceId, String? serviceName, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext localContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text(
            "Are you sure you want to delete the service '${serviceName ?? "No title"}'?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(localContext).pop(false),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.of(localContext)
                    .pop(true); // Close the confirmation dialog
                try {
                  await _businessService.deleteService(widget.token, serviceId);
                  // Show green check and "Service deleted" message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Service deleted",
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting service: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.add,
                            insertNewLinesEveryThreeWords(
                                'Create a new service'),
                            () => _showCreateServicePanel(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.edit,
                            insertNewLinesEveryThreeWords('Update a service'),
                            _showAllServicesForUpdate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.delete,
                            insertNewLinesEveryThreeWords('Delete a service'),
                            _deleteServicesPanel,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.search,
                            insertNewLinesEveryThreeWords(
                                'Retrieve a specific service'),
                            _showSpecificServicesPanel,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.list,
                            insertNewLinesEveryThreeWords(
                                'Retrieve all services'),
                            _businessServices,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _buildButtonWithIconAndText(
                            Icons.filter_list,
                            insertNewLinesEveryThreeWords(
                                'Retrieve services filtering by professional family'),
                            _showProFamiliesPanel,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllServicesForUpdate() async {
    _showLoadingDialog();
    try {
      final services = await _businessService.getBusinessServices(widget.token);
      Navigator.pop(context);

      if (services != null && services.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Select Service"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: services.map((ServicioModel service) {
                    return ListTile(
                      title: Text(service.title ?? 'No title'),
                      onTap: () {
                        Navigator.pop(context);
                        _editServiceDetails(service);
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No services available for editing")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _editServiceDetails(ServicioModel service) {
    final _titleController = TextEditingController(text: service.title);
    final _descriptionController =
        TextEditingController(text: service.description);
    ProFamilyModel? _selectedProfesionalFamily = service.profesionalFamilyId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Service"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    DropdownButton<ProFamilyModel>(
                      value: _selectedProfesionalFamily,
                      hint: const Text("Select Professional Family"),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProfesionalFamily = newValue;
                        });
                      },
                      items: _profesionalFamilies.map((ProFamilyModel family) {
                        return DropdownMenuItem<ProFamilyModel>(
                          value: family,
                          child: Text(family.name ?? 'Nombre no disponible'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    if (_selectedProfesionalFamily == null ||
                        _titleController.text.isEmpty ||
                        _titleController.text.length > 30 ||
                        _descriptionController.text.isEmpty ||
                        _descriptionController.text.length > 60) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Please fill all the fields '),
                            ],
                          ),
                        ),
                      );
                    } else {
                      try {
                        final updatedService = ServicioModel(
                          id: service.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          profesionalFamilyId: _selectedProfesionalFamily,
                        );
                        await _businessService.updateService(
                            widget.token, service.id!, updatedService);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Service updated successfully'),
                              ],
                            ),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(
                            context); // También cierra el diálogo si hay un error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating service: $e')),
                        );
                      }
                    }
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(
                        context); // Cierra el diálogo sin realizar cambios
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showProFamiliesPanel() async {
    _showLoadingDialog(); // Mostrar el diálogo de carga
    try {
      final proFamilies =
          await _proFamilyService.getProfesionalFamilies(widget.token);
      Navigator.pop(
          context); // Cierra el diálogo de carga aquí, antes de mostrar las familias profesionales

      if (proFamilies != null) {
        showDialog(
          context: context,
          builder: (BuildContext localContext) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(localContext).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: proFamilies.length,
                        itemBuilder: (BuildContext context, int index) {
                          final proFamily = proFamilies[index];
                          return ListTile(
                            title: Text(proFamily.name ?? "No name"),
                            onTap: () {
                              Navigator.of(context)
                                  .pop(); // Cerrar el diálogo actual
                              _showServicesForProFamily(proFamily
                                  .id!); // Muestra servicios para la familia profesional
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("No se pudieron cargar las familias profesionales")),
        );
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegurarse de cerrar el diálogo de carga en caso de un error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar familias profesionales: $e")),
      );
    }
  }

  void _showServicesForProFamily(int proFamilyId) async {
    _showLoadingDialog(); // Mostrar el diálogo de carga antes de cargar los servicios

    try {
      final services = await _businessService.getBusinessProFamServices(
          widget.token, proFamilyId);
      Navigator.pop(
          context); // Cierra el diálogo de carga antes de la navegación

      if (services != null && services.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BusinessCards(servicios: services)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("This profesional family has no services")),
        );
      }
    } catch (e) {
      Navigator.pop(
          context); // Asegúrate de cerrar el diálogo de carga en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error retrieving services: $e")),
      );
    }
  }

  String insertNewLinesEveryThreeWords(String text) {
    final words = text.split(' ');
    var newText = '';
    for (int i = 0; i < words.length; i++) {
      newText += words[i];
      if ((i + 1) % 3 == 0 && i != words.length - 1) {
        newText += '\n';
      } else if (i != words.length - 1) {
        newText += ' ';
      }
    }
    return newText;
  }

  Widget _buildButtonWithIconAndText(
      IconData icon, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 40, color: Colors.white),
            onPressed: onPressed,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "No date";
    return "${date.day}-${date.month}-${date.year}";
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
