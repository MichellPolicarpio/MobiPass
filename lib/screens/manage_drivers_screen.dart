import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../main.dart';

class ManageDriversScreen extends StatefulWidget {
  const ManageDriversScreen({super.key});

  @override
  State<ManageDriversScreen> createState() => _ManageDriversScreenState();
}

class _ManageDriversScreenState extends State<ManageDriversScreen> {
  List<User> _drivers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await http.get(
        Uri.parse('$serverUrl/api/auth/driver'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> driversJson = json.decode(response.body);
        setState(() {
          _drivers = driversJson.map((json) => User.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error al cargar transportistas: ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar transportistas: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDriver(String driverId) async {
    try {
      final response = await http.delete(
        Uri.parse('$serverUrl/api/auth/driver/$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _loadDrivers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transportista eliminado exitosamente')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar transportista: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar transportista: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _loadDriverStats(String driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/api/auth/driver/$driverId/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar estadísticas');
      }
    } catch (e) {
      throw Exception('Error al cargar estadísticas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDrivers,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_drivers.isEmpty) {
      return const Center(
        child: Text('No hay transportistas registrados'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Transportistas'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDrivers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar transportistas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implementar búsqueda
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDrivers,
              child: ListView.builder(
                itemCount: _drivers.length,
                itemBuilder: (context, index) {
                  final driver = _drivers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: Text(
                          driver.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(driver.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.email),
                          Text(
                            'ID: ${driver.id}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditDialog(driver),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(driver),
                          ),
                        ],
                      ),
                      children: [
                        FutureBuilder<Map<String, dynamic>>(
                          future: _loadDriverStats(driver.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            final stats = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow('Número de Licencia', driver.licenseNumber ?? 'No especificado'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Número de Autobús', driver.busNumber ?? 'No especificado'),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatCard('Tickets Escaneados', stats['ticketsScanned'].toString()),
                                      _buildStatCard('Rutas Completadas', stats['routesCompleted'].toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatCard('Horas Trabajadas', stats['hoursWorked'].toString()),
                                      _buildStatCard('Calificación', '${stats['rating']}/5'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final licenseController = TextEditingController();
    final busController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Transportista'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: licenseController,
                decoration: const InputDecoration(
                  labelText: 'Número de Licencia',
                  icon: Icon(Icons.card_membership),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: busController,
                decoration: const InputDecoration(
                  labelText: 'Número de Autobús',
                  icon: Icon(Icons.directions_bus),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await http.post(
                  Uri.parse('$serverUrl/api/auth/driver/signup'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'name': nameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'licenseNumber': licenseController.text,
                    'busNumber': busController.text,
                  }),
                );

                if (response.statusCode == 201) {
                  if (mounted) {
                    Navigator.pop(context);
                    _loadDrivers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transportista agregado exitosamente')),
                    );
                  }
                } else {
                  throw Exception(response.body);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al agregar transportista: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(User driver) {
    final nameController = TextEditingController(text: driver.name);
    final emailController = TextEditingController(text: driver.email);
    final licenseController = TextEditingController(text: driver.licenseNumber);
    final busController = TextEditingController(text: driver.busNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Transportista'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: licenseController,
                decoration: const InputDecoration(
                  labelText: 'Número de Licencia',
                  icon: Icon(Icons.card_membership),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: busController,
                decoration: const InputDecoration(
                  labelText: 'Número de Autobús',
                  icon: Icon(Icons.directions_bus),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await http.put(
                  Uri.parse('$serverUrl/api/auth/driver/${driver.id}'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'name': nameController.text,
                    'email': emailController.text,
                    'licenseNumber': licenseController.text,
                    'busNumber': busController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  if (mounted) {
                    Navigator.pop(context);
                    _loadDrivers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transportista actualizado exitosamente')),
                    );
                  }
                } else {
                  throw Exception(response.body);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar transportista: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(User driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Transportista'),
        content: Text('¿Estás seguro de que deseas eliminar a ${driver.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDriver(driver.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
} 