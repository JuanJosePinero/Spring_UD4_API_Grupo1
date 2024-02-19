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
  late ProFamilyService
      _proFamilyService; // Servicio para las familias profesionales
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
    final families = await _proFamilyService.getProfesionalFamilies(
        'Bearer${widget.token}'); // Asume que tienes este método
    setState(() {
      _profesionalFamilies = families;
    });
  }

  void _businessServices() async {
    try {
      final services = await _businessService.getBusinessServices(widget.token);
      if (services != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: services),
          ),
        );
        print("$services");
      } else {
        // Mostrar mensaje de error si no hay servicios
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No se pudieron recuperar los servicios")),
        );
      }
    } catch (e) {
      // Manejar cualquier otro error
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
    final services = await _businessService.getBusinessServices(widget.token);
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
                          title: Text(services[index].title ?? "Sin título"),
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Usamos el context del builder
                            // Corregido para llamar al método con el contexto correcto y el ID de servicio
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
  }

  void _showSpecificServiceDetailsPanel(int? serviceId) async {
    if (serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID de servicio no válido")),
      );
      return;
    }

    final serviceDetails = await _businessService.getBusinessSpecificService(
        widget.token, serviceId);

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
                  // Agrega aquí más detalles que quieras mostrar
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
  }

  void _showCreateServicePanel() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future:
              _loadProFamilies(), // Llama a la función _loadProFamilies aquí
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // Una vez que las familias profesionales estén disponibles, muestra el diálogo de creación de servicio
              return AlertDialog(
                title: const Text("Create New Service"),
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
                            _selectedProfesionalFamily = newValue!;
                          });
                        },
                        items:
                            _profesionalFamilies.map((ProFamilyModel family) {
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

  // Método modificado para incluir un botón de eliminación en cada ListTile
// void _deleteServicesPanel() async {
//   final services = await _businessService.getBusinessServices(widget.token);
//   if (services != null) {
//     showDialog(
//       context: context,
//       builder: (BuildContext localContext) {
//         return Dialog(
//           child: Container(
//             padding: const EdgeInsets.all(20.0),
//             height: MediaQuery.of(localContext).size.height * 0.5,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: services.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (services[index].id != null) {
//                         return ListTile(
//                           title: Text(services[index].title ?? "No title"),
//                           onTap: () {
//                             Navigator.of(localContext).pop();
//                             // Aquí pasamos 'context' en lugar de 'localContext' para asegurarnos de que sea el contexto de la pantalla principal
//                             _confirmDeleteService(services[index].id!, services[index].title, context);
//                           },
//                         );
//                       } else {
//                         return ListTile(
//                           title: Text(services[index].title ?? "No title"),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("No se pudieron cargar los servicios")),
//     );
//   }
// }

// void _confirmDeleteService(int serviceId, String? serviceName, BuildContext mainContext) async {
//   showDialog(
//     context: mainContext,
//     builder: (BuildContext localContext) {
//       return AlertDialog(
//         title: Text("Eliminar Servicio"),
//         content: Text("¿Deseas eliminar el servicio '${serviceName ?? "Sin título"}'?"),
//         actions: <Widget>[
//           TextButton(
//             child: Text("Cancelar"),
//             onPressed: () => Navigator.of(localContext).pop(),
//           ),
//           TextButton(
//             child: Text("Eliminar"),
//             onPressed: () async {
//               try {
//                 await _businessService.deleteService(widget.token, serviceId);
//                 Navigator.of(localContext).pop(); // Cerrar el diálogo de confirmación
//                 // Aquí, usamos 'mainContext' para mostrar el SnackBar desde el contexto de la pantalla principal
//                 showCustomSnackBar(mainContext, "Servicio eliminado exitosamente");
//               } catch (e) {
//                 showCustomSnackBar(mainContext, "Error al eliminar el servicio: $e");
//               }
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void showCustomSnackBar(BuildContext context, String message) {
//   final scaffold = ScaffoldMessenger.of(context);
//   scaffold.showSnackBar(
//     SnackBar(content: Text(message)),
//   );
// }

  void showFloatingPanel(BuildContext context, bool isSuccess) {
    Future.delayed(Duration.zero, () {
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (overlayContext) => Positioned(
          top: MediaQuery.of(overlayContext).size.height * 0.4,
          left: MediaQuery.of(overlayContext).size.width * 0.1,
          right: MediaQuery.of(overlayContext).size.width * 0.1,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 60,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isSuccess
                          ? "Deleted service successfully"
                          : "Service not deleted",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      Overlay.of(context)?.insert(overlayEntry);

      // Eliminar el overlay después de un corto período
      Future.delayed(const Duration(seconds: 3), () {
        overlayEntry.remove();
      });
    });
  }

  void _deleteServicesPanel() async {
    final services = await _businessService.getBusinessServices(widget.token);
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
                        if (services[index].id != null) {
                          return ListTile(
                            title: Text(services[index].title ?? "No title"),
                            onTap: () {
                              Navigator.of(localContext).pop();
                              _confirmDeleteService(services[index].id!,
                                  services[index].title, context);
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
    } else {
      showFloatingPanel(context, false);
    }
  }

  void _confirmDeleteService(
      int serviceId, String? serviceName, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext localContext) {
        return AlertDialog(
          title: const Text("Eliminar Servicio"),
          content: Text(
              "¿Deseas eliminar el servicio '${serviceName ?? "Sin título"}'?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(localContext).pop(),
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () async {
                try {
                  await _businessService.deleteService(widget.token, serviceId);
                  Navigator.of(localContext)
                      .pop(); // Cerrar el diálogo de confirmación
                  showFloatingPanel(context, true); // Muestra el panel de éxito
                } catch (e) {
                  showFloatingPanel(
                      context, false); // Muestra el panel de error
                }
              },
            ),
          ],
        );
      },
    );
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
                    () => _showCreateServicePanel(),
                  ),
                  _buildButtonWithIconAndText(
                      Icons.search,
                      'Recuperar un determinado servicio de la empresa logueada',
                      _showSpecificServicesPanel),
                  _buildButtonWithIconAndText(
                    Icons.list,
                    'Recuperar todos los servicios de la empresa logueada',
                    _businessServices,
                  ),
                  _buildButtonWithIconAndText(
                      Icons.edit,
                      'Actualizar un servicio de la empresa logueada',
                      _showAllServicesForUpdate),
                  _buildButtonWithIconAndText(
                      Icons.delete,
                      'Eliminar un servicio de la empresa logueada',
                      _deleteServicesPanel),
                  _buildButtonWithIconAndText(
                      Icons.filter_list,
                      'Recuperar los servicios de una empresa filtrando por familia profesional',
                      _showProFamiliesPanel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllServicesForUpdate() async {
    try {
      // Obtener todos los servicios de la empresa
      final services = await _businessService.getBusinessServices(widget.token);

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
                        Navigator.pop(
                            context); // Cerrar el diálogo de selección
                        _editServiceDetails(
                            service); // Mostrar detalles del servicio seleccionado para edición
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
                  decoration: const InputDecoration(labelText: 'Description'),
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
                try {
                  final updatedService = ServicioModel(
                    id: service.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    profesionalFamilyId: _selectedProfesionalFamily,
                    // Ajusta los campos según tu modelo de datos
                  );
                  await _businessService.updateService(
                      widget.token, service.id!, updatedService);
                  Navigator.pop(
                      context); // Cierra el diálogo después de la operación exitosa
                } catch (e) {
                  Navigator.pop(
                      context); // También cierra el diálogo si hay un error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating service: $e')),
                  );
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
  }

  void _showProFamiliesPanel() async {
    final proFamilies =
        await _proFamilyService.getProfesionalFamilies(widget.token);
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
                          title: Text(proFamily.name ?? "Sin nombre"),
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Cierra el panel flotante
                            // Aquí puedes llamar a otro método que maneje la acción deseada tras seleccionar una familia profesional
                            // Por ejemplo, cargar servicios específicos para esa familia profesional
                            _showServicesForProFamily(proFamily.id!);
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
            content: Text("No se pudieron cargar las familias profesionales")),
      );
    }
  }

  void _showServicesForProFamily(int proFamilyId) async {
    try {
      // Obtener los servicios para la familia profesional seleccionada
      final services = await _businessService.getBusinessProFamServices(
        widget.token,
        proFamilyId,
      );

      if (services != null && services.isNotEmpty) {
        // Mostrar los servicios en una nueva página
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: services),
          ),
        );
      } else {
        // Mostrar mensaje de error si no hay servicios
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "No se encontraron servicios para esta familia profesional"),
          ),
        );
      }
    } catch (e) {
      // Manejar cualquier error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al recuperar servicios: $e"),
        ),
      );
    }
  }

  Widget _buildButtonWithIconAndText(
      IconData icon, String text, VoidCallback onPressed) {
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
