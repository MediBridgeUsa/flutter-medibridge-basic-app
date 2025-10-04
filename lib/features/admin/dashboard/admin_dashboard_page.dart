import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/auth_providers.dart'; // El proveedor correcto ya está importado

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // ¡CORREGIDO! Usa el authServiceProvider para el signOut
              ref.read(authServiceProvider.notifier).signOut(); 
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildDashboardCard(context, 'Users', Icons.people, '/admin/users'),
          _buildDashboardCard(context, 'Roles', Icons.security, '/admin/roles'),
          _buildDashboardCard(
              context, 'Companies', Icons.business, '/admin/companies'),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0),
            const SizedBox(height: 8.0),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
