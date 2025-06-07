import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ticket.dart';
import '../models/user.dart';

class BuyTicketsScreen extends StatefulWidget {
  final User user;
  final Function(List<Ticket>) onTicketsPurchased;

  const BuyTicketsScreen({
    super.key,
    required this.user,
    required this.onTicketsPurchased,
  });

  @override
  State<BuyTicketsScreen> createState() => _BuyTicketsScreenState();
}

class _BuyTicketsScreenState extends State<BuyTicketsScreen> {
  int _studentTickets = 0;
  int _adultTickets = 0;
  bool _isLoading = false;

  double get _totalPrice => (_studentTickets * 7.0) + (_adultTickets * 9.0);

  Future<void> _purchaseTickets() async {
    if (_studentTickets == 0 && _adultTickets == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un boleto')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // IDs de la base de datos
      const routeId = '683c5676a2e3db151d5a2447'; // Ruta 1
      const busId = '683c5676a2e3db151d5a244b'; // Bus ABC123
      const seatNumber = 1;
      final departureTime = DateTime.now().add(const Duration(days: 1));

      // Preparar boletos de estudiante
      for (var i = 0; i < _studentTickets; i++) {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/tickets/purchase'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.user.token}',
          },
          body: json.encode({
            'routeId': routeId,
            'busId': busId,
            'seatNumber': seatNumber + i,
            'departureTime': departureTime.toIso8601String(),
            'price': 7.0,
            'passengerName': 'Estudiante ${i + 1}',
            'passengerId': 'EST${i + 1}',
          }),
        );

        if (response.statusCode != 201) {
          throw Exception('Error al comprar boleto de estudiante');
        }
      }

      // Preparar boletos de adulto
      for (var i = 0; i < _adultTickets; i++) {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/tickets/purchase'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.user.token}',
          },
          body: json.encode({
            'routeId': routeId,
            'busId': busId,
            'seatNumber': seatNumber + _studentTickets + i,
            'departureTime': departureTime.toIso8601String(),
            'price': 9.0,
            'passengerName': 'Adulto ${i + 1}',
            'passengerId': 'ADU${i + 1}',
          }),
        );

        if (response.statusCode != 201) {
          throw Exception('Error al comprar boleto de adulto');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Compra exitosa!')),
        );
        
        // Crear lista de boletos comprados
        final List<Ticket> purchasedTickets = [];
        
        // Agregar boletos de estudiante
        for (var i = 0; i < _studentTickets; i++) {
          purchasedTickets.add(Ticket(
            routeId: routeId,
            busId: busId,
            seatNumber: seatNumber + i,
            departureTime: departureTime,
            price: 7.0,
            passengerName: 'Estudiante ${i + 1}',
            passengerId: 'EST${i + 1}',
          ));
        }
        
        // Agregar boletos de adulto
        for (var i = 0; i < _adultTickets; i++) {
          purchasedTickets.add(Ticket(
            routeId: routeId,
            busId: busId,
            seatNumber: seatNumber + _studentTickets + i,
            departureTime: departureTime,
            price: 9.0,
            passengerName: 'Adulto ${i + 1}',
            passengerId: 'ADU${i + 1}',
          ));
        }
        
        // Notificar sobre los boletos comprados
        widget.onTicketsPurchased(purchasedTickets);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
        title: const Text('Comprar Boletos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de boletos de estudiante
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Boleto de Estudiante',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$7.00',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _studentTickets > 0
                              ? () => setState(() => _studentTickets--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          _studentTickets.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _studentTickets++),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sección de boletos de adulto
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Boleto de Adulto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$9.00',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _adultTickets > 0
                              ? () => setState(() => _adultTickets--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          _adultTickets.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _adultTickets++),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Total y botón de compra
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _purchaseTickets,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Comprar Boletos',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 