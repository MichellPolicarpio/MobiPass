import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as Math;
import '../models/user.dart';
import '../models/report.dart';
import '../main.dart';
import 'report_screen.dart';

class ReportHistoryScreen extends StatefulWidget {
  final User user;

  const ReportHistoryScreen({
    super.key,
    required this.user,
  });

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Pendientes', 'En Proceso', 'Resueltos'];
  List<Report> _reports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$serverUrl/api/reports'),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _reports = data.map((json) => Report.fromJson(json)).toList();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar reportes: ${response.body}'),
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

  List<Report> _getFilteredReports() {
    if (_selectedFilter == 'Todos') return _reports;
    
    String statusFilter = _selectedFilter.toLowerCase();
    if (statusFilter == 'pendientes') statusFilter = 'pendiente';
    else if (statusFilter == 'en proceso') statusFilter = 'en proceso';
    else if (statusFilter == 'resueltos') statusFilter = 'resuelto';
    
    return _reports.where((report) => 
      report.status.toLowerCase() == statusFilter
    ).toList();
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    IconData iconData;
    
    switch (status.toLowerCase()) {
      case 'pendiente':
        chipColor = Colors.orange;
        iconData = Icons.pending;
        break;
      case 'en proceso':
        chipColor = Colors.blue;
        iconData = Icons.sync;
        break;
      case 'resuelto':
        chipColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      default:
        chipColor = Colors.grey;
        iconData = Icons.help;
    }

    return Chip(
      avatar: Icon(iconData, size: 16, color: Colors.white),
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _getFilteredReports();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Reportes'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por estado:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(filter),
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredReports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No hay reportes disponibles',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadReports,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Recargar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: ExpansionTile(
                          title: Text(
                            report.id != null 
                                ? 'Reporte #${report.id!.substring(0, Math.min(8, report.id!.length))}' 
                                : 'Reporte Nuevo',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Matrícula: ${report.driverLicense}'),
                              Text('Ruta: ${report.route}'),
                              const SizedBox(height: 4),
                              _buildStatusChip(report.status),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Descripción de la Queja:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    report.complaint,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Fecha: ${report.createdAt.toString().split('.')[0]}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(user: widget.user),
            ),
          );
          if (result == true) {
            _loadReports();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
} 