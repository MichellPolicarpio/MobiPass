import 'package:flutter/material.dart';
import '../models/user.dart';
import 'manage_users_screen.dart';
import 'manage_drivers_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final User user;

  const AdminHomeScreen({super.key, required this.user});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
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
                color: Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.admin_panel_settings, color: Colors.purple, size: 40),
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
              leading: const Icon(Icons.people),
              title: const Text('Gestionar Usuarios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageUsersScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text('Gestionar Transportistas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageDriversScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Ver Reportes'),
              onTap: () {
                // TODO: Implementar vista de reportes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función en desarrollo'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta de bienvenida
              Card(
                elevation: 4,
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
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Panel de Administración de MobiPass',
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

              // Acciones principales
              const Text(
                'Acciones Principales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.people,
                      title: 'Gestionar Usuarios',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageUsersScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.directions_bus,
                      title: 'Gestionar Transportistas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageDriversScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                icon: Icons.report,
                title: 'Ver Reportes',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función en desarrollo'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Información legal y de contacto
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información del Sistema',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('Universidad Veracruzana'),
                        subtitle: Text('Facultad de Ingeniería Eléctrica y Electrónica'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Desarrolladores'),
                        subtitle: Text('Michell Alexis Policarpio Moran\nIsabella Coria Juarez'),
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Materia'),
                        subtitle: Text('Base de Datos Distribuidas y en la Nube'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text('Profesora'),
                        subtitle: Text('Primavera Arguelles Lucho'),
                      ),
                      Divider(),
                      Text(
                        '© 2024 MobiPass. Todos los derechos reservados.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.purple),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 