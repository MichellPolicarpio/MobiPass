import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/report.dart';
import '../main.dart';

class ReportScreen extends StatefulWidget {
  final User user;
  
  const ReportScreen({
    super.key,
    required this.user,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverLicenseController = TextEditingController();
  final _complaintController = TextEditingController();
  bool _isLoading = false;
  String? _selectedRoute;

  // Lista de rutas disponibles
  final List<String> _routes = [
    'Boca del Rio Penacho',
    'Bolivar Lomas',
    'Comercial Mexicana',
    'Norte Sur'
  ];

  @override
  void dispose() {
    _driverLicenseController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione una ruta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/reports'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}',
        },
        body: json.encode({
          'driverLicense': _driverLicenseController.text,
          'route': _selectedRoute,
          'complaint': _complaintController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte creado con éxito'),
              backgroundColor: Colors.green,
            ),
          );

          // Limpiar el formulario
          _driverLicenseController.clear();
          _complaintController.clear();
          setState(() {
            _selectedRoute = null;
          });

          // Volver a la pantalla anterior
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Reporte'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _driverLicenseController,
                        decoration: const InputDecoration(
                          labelText: 'Matrícula del Conductor',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                          hintText: 'Ej: ABC123',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la matrícula del conductor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRoute,
                        decoration: const InputDecoration(
                          labelText: 'Seleccionar Ruta',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.route),
                        ),
                        items: _routes.map((String route) {
                          return DropdownMenuItem<String>(
                            value: route,
                            child: Text(route),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRoute = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor seleccione una ruta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _complaintController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Descripción de la Queja',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.comment),
                          alignLabelWithHint: true,
                          hintText: 'Describa el motivo de su queja...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la descripción de su queja';
                          }
                          if (value.length < 10) {
                            return 'La descripción debe tener al menos 10 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Enviar Reporte',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 