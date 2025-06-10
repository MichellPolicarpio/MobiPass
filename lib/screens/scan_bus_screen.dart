import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanBusScreen extends StatefulWidget {
  const ScanBusScreen({super.key});

  @override
  State<ScanBusScreen> createState() => _ScanBusScreenState();
}

class _ScanBusScreenState extends State<ScanBusScreen> {
  final _busNumberController = TextEditingController();
  bool _isValidating = false;
  bool? _isValid;
  int _remainingTickets = 5; // Ejemplo de tickets disponibles

  void _validateBusNumber() {
    setState(() {
      _isValidating = true;
    });

    // Simulación de validación
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isValidating = false;
        _isValid = true;
        if (_isValid!) {
          _remainingTickets--;
        }
      });

      // Mostrar resultado
      _showValidationResult();
    });
  }

  void _showValidationResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                _isValid! ? Icons.check_circle : Icons.error,
                color: _isValid! ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(_isValid! ? '¡Boleto Validado!' : 'Error de Validación'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isValid! 
                  ? 'Tu boleto ha sido validado exitosamente.'
                  : 'No se pudo validar el boleto. Verifica el número de bus.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (_isValid!) ...[
                const Text(
                  'Detalles del viaje:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• Ruta: Xalapa - UV'),
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
              onPressed: () => Navigator.of(context).pop(),
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
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              // Botón de validación
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isValidating || _busNumberController.text.isEmpty
                      ? null
                      : _validateBusNumber,
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
                      : const Text(
                          'Validar Boleto',
                          style: TextStyle(fontSize: 16),
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
    _busNumberController.dispose();
    super.dispose();
  }
} 