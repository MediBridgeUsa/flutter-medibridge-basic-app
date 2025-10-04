
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: userProfile.when(
        data: (userDoc) {
          if (userDoc == null || !userDoc.exists) {
            return const Center(child: Text('No se encontró el perfil de usuario.'));
          }
          final userData = userDoc.data() as Map<String, dynamic>;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    userData['email']?[0].toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${userData['email'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authServiceProvider.notifier).signOut();
                  },
                  child: const Text('Cerrar Sesión'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
