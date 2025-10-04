
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/auth_providers.dart';

class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ¡CAMBIO CLAVE! Usamos el provider que nos da la instancia directa del servicio.
    final authService = ref.read(authServiceInstanceProvider); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud Pendiente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Ahora authService es una instancia de AuthService y tiene el método signOut.
              await authService.signOut();
              // El AuthWrapper se encargará de redirigir a /login.
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top_rounded, size: 64, color: Colors.amber),
              const SizedBox(height: 24),
              Text(
                'Tu solicitud de acceso está pendiente de aprobación.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Un administrador revisará tu solicitud pronto. Gracias por tu paciencia.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
