import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/ticket.dart';
import 'buy_tickets_screen.dart';
import 'help_screen.dart';
import 'routes_screen.dart';
import 'report_screen.dart';
import 'report_history_screen.dart';
import '../main.dart';
import 'scan_bus_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final int activeTickets;

  const HomeScreen({
    super.key,
    required this.user,
    required this.activeTickets,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _activeTickets;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _activeTickets = widget.activeTickets;
    _loadActiveTickets();
  }

  Future<void> _loadActiveTickets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/tickets/active/count'),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _activeTickets = data['count'];
        });
      }
    } catch (e) {
      // Manejar error
    }
  }

  void _handleTicketsPurchased(List<Ticket> newTickets) {
    setState(() {
      _activeTickets += newTickets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobiPass'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              print('Abriendo configuración...'); // Debug print
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'MobiPass',
                  applicationVersion: '1.0.0',
                  applicationIcon: const FlutterLogo(size: 64),
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Creadores:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('• Michell Alexis Policarpio Moran'),
                    const Text('• Isabella Coria Juarez'),
                    const SizedBox(height: 16),
                    const Text(
                      'Profesora:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Primavera Arguelles Lucho'),
                    const SizedBox(height: 16),
                    const Text(
                      'Materia:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Base de Datos Distribuidas y en la Nube'),
                    const SizedBox(height: 16),
                    const Text(
                      'Facultad:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Ingeniería Eléctrica y Electrónica'),
                    const SizedBox(height: 16),
                    const Text(
                      'Universidad:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Universidad Veracruzana'),
                  ],
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mensaje de bienvenida
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido, ${widget.user.name}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tu aplicación de transporte público',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sección de boletos vigentes
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Boletos Vigentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _activeTickets.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botones de acción
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'Comprar Boletos',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyTicketsScreen(
                            user: widget.user,
                            onTicketsPurchased: _handleTicketsPurchased,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Validar Boleto',
                    subtitle: 'Ingresa el número de bus',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanBusScreen(user: widget.user),
                        ),
                      ).then((_) {
                        // Recargar los boletos cuando regrese
                        _loadActiveTickets();
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.route,
                    label: 'Ver Rutas',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.report,
                    label: 'Realizar Reporte',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportScreen(user: widget.user),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.history,
                    label: 'Historial de Reportes',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportHistoryScreen(user: widget.user),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.settings,
                    label: 'Configuración',
                    onPressed: () {
                      print('Abriendo configuración desde el grid...'); // Debug print
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(user: widget.user),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 2,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
} 