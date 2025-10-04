import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/widgets/side_menu.dart'; // Importación corregida

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      drawer: const SideMenu(), // Widget corregido
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAdminCard(
            context,
            icon: Icons.people,
            title: 'User Management',
            subtitle: 'Approve, deny, and manage user roles.',
            onTap: () => context.go('/admin/users'),
          ),
          const SizedBox(height: 16),
          _buildAdminCard(
            context,
            icon: Icons.security,
            title: 'Role Management',
            subtitle: 'Define and manage user roles and permissions.',
            onTap: () => context.go('/admin/roles'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
