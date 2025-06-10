import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';

class DriverHomeScreen extends StatefulWidget {
  final User user;

  const DriverHomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  void _showDriverIdDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text('Identificador del Bus'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Muestra este número al usuario para validar el bus:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.busNumber ?? 'No asignado',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.orange),
                      onPressed: () {
                        if (widget.user.busNumber != null) {
                          Clipboard.setData(ClipboardData(text: widget.user.busNumber!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Número de bus copiado al portapapeles'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      tooltip: 'Copiar al portapapeles',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Instrucciones:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. El usuario debe ingresar este número en su app\n'
                '2. Verifica que el número ingresado coincida\n'
                '3. Confirma el pasaje una vez validado',
                style: TextStyle(fontSize: 14),
              ),
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
        title: const Text('Portal Transportista'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información del Transportista
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.user.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bus Number: ${widget.user.busNumber ?? "No asignado"}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Información del Vehículo y Licencia
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información Legal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const ListTile(
                        leading: Icon(Icons.directions_bus, color: Colors.orange),
                        title: Text('Vehículo'),
                        subtitle: Text('Mercedes-Benz Sprinter 2024\nPlacas: XYZ-123-UV'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.badge, color: Colors.orange),
                        title: Text('Licencia de Conducir'),
                        subtitle: Text('Tipo: Federal Transporte Público\nVigencia: 31/12/2025'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.verified_user, color: Colors.orange),
                        title: Text('Permisos'),
                        subtitle: Text('Transporte Universitario\nZona: Xalapa-Veracruz'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botones de Acción
              const Text(
                'Acciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Botón de Identificador de Bus
              _buildActionButton(
                icon: Icons.directions_bus,
                title: 'Mostrar Número de Bus',
                subtitle: 'Para validación de pasajes',
                onTap: _showDriverIdDialog,
              ),
              const SizedBox(height: 12),

              // Botón de Rutas
              _buildActionButton(
                icon: Icons.map,
                title: 'Mis Rutas',
                subtitle: 'Ver y gestionar rutas asignadas',
                onTap: () {
                  // TODO: Implementar vista de rutas
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abriendo rutas...')),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Botón de Cerrar Sesión
              _buildActionButton(
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                subtitle: 'Salir de la aplicación',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.orange),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
} 