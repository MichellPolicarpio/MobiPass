import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/user.dart';
import '../models/transaction.dart';
import '../main.dart';

class ScanBusScreen extends StatefulWidget {
  final User user;

  const ScanBusScreen({
    super.key,
    required this.user,
  });

  @override
  State<ScanBusScreen> createState() => _ScanBusScreenState();
}

class _ScanBusScreenState extends State<ScanBusScreen> {
  final _busNumberController = TextEditingController();
  bool _isValidating = false;
  bool? _isValid;
  int _remainingTickets = 0;
  String? _errorMessage;
  Map<String, dynamic>? _driverData;

  @override
  void initState() {
    super.initState();
    _loadRemainingTickets();
    _busNumberController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      // Esto forzará la reconstrucción del botón
    });
  }

  Future<void> _loadRemainingTickets() async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/api/tickets/active/count'),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _remainingTickets = data['count'];
        });
      }
    } catch (e) {
      print('Error loading tickets: $e');
    }
  }

  Future<void> _validateBusNumber() async {
    if (_busNumberController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa un número de bus';
      });
      return;
    }

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    try {
      print('Verificando bus número: ${_busNumberController.text}');
      
      // 1. Verificar si el bus existe
      final busResponse = await http.get(
        Uri.parse('$serverUrl/api/auth/driver/bus/${_busNumberController.text}'),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado tiempo');
        },
      );

      print('URL de verificación: $serverUrl/api/auth/driver/bus/${_busNumberController.text}');
      print('Respuesta de verificación de bus:');
      print('Status code: ${busResponse.statusCode}');
      print('Body: ${busResponse.body}');

      if (busResponse.statusCode == 404) {
        setState(() {
          _isValidating = false;
          _isValid = false;
          _errorMessage = 'Bus no encontrado. Verifica el número.';
        });
        _showValidationResult();
        return;
      }

      if (busResponse.statusCode != 200) {
        setState(() {
          _isValidating = false;
          _isValid = false;
          _errorMessage = 'Error al verificar el bus. Intenta nuevamente.';
        });
        _showValidationResult();
        return;
      }

      // 2. Validar el boleto y crear la transacción
      print('Validando boleto...');
      final driverData = json.decode(busResponse.body);
      setState(() {
        _driverData = driverData;
      });
      
      // Primero crear o obtener el bus
      final busCreateResponse = await http.post(
        Uri.parse('$serverUrl/api/buses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}',
        },
        body: json.encode({
          'plateNumber': driverData['busNumber'],
          'model': 'Default Model',
          'capacity': 50,
          'driver': {
            'name': driverData['name'],
            'license': driverData['licenseNumber'],
          }
        }),
      );

      print('Respuesta de creación de bus:');
      print('Status code: ${busCreateResponse.statusCode}');
      print('Body: ${busCreateResponse.body}');

      final busId = json.decode(busCreateResponse.body)['_id'];
      final requestBody = {
        'routeId': '683c5676a2e3db151d5a2447', // Default route
        'busId': busId,
        'seatNumber': 1,
        'departureTime': DateTime.now().toIso8601String(),
        'price': 7.0,
        'passengerName': widget.user.name,
        'passengerId': widget.user.id,
        'status': 'used', // Mark as used immediately
      };
      print('Request body for validation:');
      print(json.encode(requestBody));

      final validationResponse = await http.post(
        Uri.parse('$serverUrl/api/tickets/purchase'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.user.token}',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La validación tardó demasiado tiempo');
        },
      );

      print('URL de validación: $serverUrl/api/tickets/purchase');
      print('Respuesta de validación de boleto:');
      print('Status code: ${validationResponse.statusCode}');
      print('Body: ${validationResponse.body}');

      if (validationResponse.statusCode == 400) {
        final errorData = json.decode(validationResponse.body);
        setState(() {
          _isValid = false;
          _errorMessage = errorData['message'];
        });
        _showValidationResult();
        return;
      }

      if (validationResponse.statusCode != 201) {
        final errorData = json.decode(validationResponse.body);
        setState(() {
          _isValid = false;
          _errorMessage = errorData['message'] ?? 'Error al validar el boleto';
        });
        _showValidationResult();
        return;
      }

      setState(() {
        _isValid = true;
        _remainingTickets = _remainingTickets - 1;
        _errorMessage = null;
      });
    } catch (e, stackTrace) {
      print('Error en la validación:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isValid = false;
        _errorMessage = e is TimeoutException 
            ? 'La conexión tardó demasiado tiempo. Verifica tu conexión a internet.'
            : 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      });
    } finally {
      setState(() {
        _isValidating = false;
      });
      _showValidationResult();
    }
  }

  void _showValidationResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                _isValid == true ? Icons.check_circle : Icons.error,
                color: _isValid == true ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(_isValid == true ? '¡Boleto Validado!' : 'Error de Validación'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isValid == true
                    ? 'Tu boleto ha sido validado exitosamente.'
                    : _errorMessage ?? 'No se pudo validar el boleto. Verifica el número de bus.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (_isValid == true) ...[
                const Text(
                  'Detalles del viaje:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('• Conductor: ${_driverData?['name'] ?? 'No disponible'}'),
                Text('• Boletos restantes: $_remainingTickets'),
                Text(
                  '• Fecha: ${DateTime.now().toString().split('.')[0]}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_isValid == true) {
                  // Si la validación fue exitosa, limpiar el campo
                  _busNumberController.clear();
                }
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar Boleto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta de información
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Boletos Disponibles: $_remainingTickets',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ingresa el número de bus para validar tu boleto',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Campo de entrada del número de bus
              TextField(
                controller: _busNumberController,
                decoration: InputDecoration(
                  labelText: 'Número de Bus',
                  hintText: 'Ingresa el número del bus',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  errorText: _errorMessage,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              // Botón de validación
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _busNumberController.text.isEmpty || _isValidating
                      ? null 
                      : () {
                          if (_remainingTickets > 0) {
                            _validateBusNumber();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No tienes boletos disponibles'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isValidating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _remainingTickets > 0 ? 'Validar Boleto' : 'No hay boletos disponibles',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Instrucciones
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instrucciones:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. Solicita el número de bus al conductor\n'
                        '2. Ingresa el número en el campo de arriba\n'
                        '3. Presiona "Validar Boleto"\n'
                        '4. Espera la confirmación\n'
                        '5. Muestra la confirmación al conductor',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _busNumberController.removeListener(_onTextChanged);
    _busNumberController.dispose();
    super.dispose();
  }
} 