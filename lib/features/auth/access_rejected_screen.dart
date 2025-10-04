
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/auth_providers.dart';

class AccessRejectedScreen extends ConsumerWidget {
  const AccessRejectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ¡CAMBIO CLAVE! Usamos el provider que nos da la instancia directa del servicio.
    final authService = ref.read(authServiceInstanceProvider); 
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceso Denegado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Ahora authService es una instancia de AuthService y tiene el método signOut.
              await authService.signOut();
              // El AuthWrapper se encargará de la redirección.
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.gpp_bad_outlined, size: 64, color: Colors.red[700]),
              const SizedBox(height: 24),
              Text(
                'Tu solicitud de acceso ha sido denegada.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red[900]),
              ),
              const SizedBox(height: 16),
              Text(
                'Si crees que esto es un error, por favor, contacta con el soporte técnico de tu organización.',
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
