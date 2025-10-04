import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/setup/seed_database.dart';

class DeveloperToolsPage extends StatelessWidget {
  const DeveloperToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas de Desarrollador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esta página solo está disponible en modo debug.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Solo permite la ejecución en modo debug
                if (kDebugMode) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Iniciando sembrado de base de datos...')),
                  );
                  await seedDatabase();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Sembrado completado!')),
                  );
                } else {
                   if (!context.mounted) return;
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Acción solo permitida en modo debug.')),
                  );
                }
              },
              child: const Text('Poblar Base de Datos (Seed)'),
            ),
          ],
        ),
      ),
    );
  }
}
