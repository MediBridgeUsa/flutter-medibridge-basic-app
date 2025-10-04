import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Users'),
            onTap: () {
              context.go('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Roles'),
            onTap: () {
              context.go('/admin/roles');
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Companies'),
            onTap: () {
              context.go('/admin/companies');
            },
          ),
           ListTile(
            leading: const Icon(Icons.personal_injury_outlined),
            title: const Text('Patients'),
            onTap: () {
              context.go('/patient-management/patients');
            },
          ),
        ],
      ),
    );
  }
}
