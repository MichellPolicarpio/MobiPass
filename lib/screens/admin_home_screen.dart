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
  int _selectedIndex = 0;

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
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestionar Usuarios'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text('Gestionar Transportistas'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: const Text('Tickets Escaneados'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Gestionar Rutas'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const ManageUsersScreen();
      case 2:
        return const ManageDriversScreen();
      case 3:
        return const Center(child: Text('Tickets Escaneados'));
      case 4:
        return const Center(child: Text('Gestión de Rutas'));
      case 5:
        return const Center(child: Text('Configuración'));
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(
          'Usuarios Activos',
          '124',
          Icons.people,
          Colors.blue,
        ),
        _buildDashboardCard(
          'Transportistas',
          '45',
          Icons.directions_bus,
          Colors.orange,
        ),
        _buildDashboardCard(
          'Tickets Hoy',
          '567',
          Icons.confirmation_number,
          Colors.green,
        ),
        _buildDashboardCard(
          'Rutas Activas',
          '12',
          Icons.route,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navegar según la tarjeta seleccionada
          switch (title) {
            case 'Usuarios Activos':
              setState(() => _selectedIndex = 1);
              break;
            case 'Transportistas':
              setState(() => _selectedIndex = 2);
              break;
            case 'Tickets Hoy':
              setState(() => _selectedIndex = 3);
              break;
            case 'Rutas Activas':
              setState(() => _selectedIndex = 4);
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 