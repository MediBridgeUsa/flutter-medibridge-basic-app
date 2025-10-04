
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ¡CAMBIO CLAVE! Ocultamos el provider incorrecto de este archivo.
import 'package:myapp/features/auth/auth_providers.dart' hide userProfileProvider;
import 'package:myapp/features/auth/login_page.dart';
import 'package:myapp/features/auth/pending_approval_screen.dart';
import 'package:myapp/features/dashboard/dashboard_screen.dart';
// Dejamos que el provider de este archivo sea la única fuente de verdad.
import 'package:myapp/features/user/user_provider.dart'; 

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (firebaseUser) {
        if (firebaseUser == null) {
          return const LoginPage();
        }

        // ¡CORREGIDO! Usamos el provider.family con el uid.
        final userProfile = ref.watch(userProfileProvider(firebaseUser.uid));

        return userProfile.when(
          data: (profile) {
            if (profile == null) {
              // El perfil aún se está creando, muestra un spinner.
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Redirección basada en el estado de aprobación.
            if (profile.isApproved) {
              return const DashboardScreen();
            } else {
              return const PendingApprovalScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) {
            // Si hay error, es más seguro enviarlo a login.
            return const LoginPage();
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const LoginPage(),
    );
  }
}
