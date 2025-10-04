import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/widgets/side_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const SideMenu(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildDashboardCard(context, 'Users', Icons.people, '/admin/users'),
          _buildDashboardCard(context, 'Roles', Icons.security, '/admin/roles'),
          _buildDashboardCard(
              context, 'Companies', Icons.business, '/admin/companies'),
          _buildDashboardCard(context, 'Patients', Icons.personal_injury_outlined,
              '/patient-management/patients'),
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
