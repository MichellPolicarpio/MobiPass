import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo usar MobiPass?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              title: 'Iniciar Sesión',
              content: 'Para iniciar sesión, ingresa tu correo electrónico y contraseña en la pantalla de inicio. Si no tienes una cuenta, puedes crear una nueva presionando "Don\'t have an account? Sign up".',
              icon: Icons.login,
            ),
            _buildHelpSection(
              title: 'Comprar Boletos',
              content: '1. Presiona el botón "Comprar Boletos"\n2. Selecciona la cantidad de boletos que deseas comprar\n3. Elige entre boletos de estudiante (\$7.00) o adulto (\$9.00)\n4. Presiona "Comprar" para confirmar tu compra',
              icon: Icons.add_circle_outline,
            ),
            _buildHelpSection(
              title: 'Escanear QR',
              content: '1. Presiona el botón "Escanear QR"\n2. Apunta la cámara hacia el código QR del autobús\n3. El sistema validará tu boleto automáticamente',
              icon: Icons.qr_code_scanner,
            ),
            _buildHelpSection(
              title: 'Ver Rutas',
              content: '1. Presiona el botón "Ver Rutas"\n2. Selecciona tu ruta de interés\n3. Verás los horarios y paradas disponibles',
              icon: Icons.route,
            ),
            _buildHelpSection(
              title: 'Realizar Reporte',
              content: '1. Presiona el botón "Realizar Reporte"\n2. Selecciona el tipo de reporte\n3. Describe el problema o situación\n4. Adjunta fotos si es necesario\n5. Envía el reporte',
              icon: Icons.report,
            ),
            _buildHelpSection(
              title: 'Historial de Reportes',
              content: '1. Presiona el botón "Historial de Reportes"\n2. Verás una lista de todos tus reportes anteriores\n3. Puedes ver el estado y detalles de cada reporte',
              icon: Icons.history,
            ),
            _buildHelpSection(
              title: 'Configuración',
              content: '1. Presiona el botón "Configuración"\n2. Aquí puedes modificar tu información personal\n3. Cambiar tu contraseña\n4. Actualizar tus preferencias',
              icon: Icons.settings,
            ),
            const SizedBox(height: 24),
            const Text(
              '¿Necesitas más ayuda?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Si tienes alguna pregunta o problema, no dudes en contactarnos a través de:\n\nEmail: soporte@mobipass.com\nTeléfono: (123) 456-7890',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
} 