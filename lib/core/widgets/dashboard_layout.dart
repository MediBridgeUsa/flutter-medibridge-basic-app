import 'package:flutter/material.dart';

import 'package:myapp/core/widgets/side_menu.dart';
import 'package:myapp/core/widgets/expandable_fab.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Asegúrate de tener un logo en esta ruta
              height: 32,
            ),
            const SizedBox(width: 16),
            if (MediaQuery.of(context).size.width > 600)
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const SideMenu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Escritorio
            return Row(
              children: [
                const SizedBox(
                  width: 250,
                  child: SideMenu(),
                ),
                Expanded(child: child),
              ],
            );
          } else {
            // Móvil
            return child;
          }
        },
      ),
      floatingActionButton: const ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            icon: Icon(Icons.add),
          ),
          ActionButton(
            icon: Icon(Icons.edit),
          ),
          ActionButton(
            icon: Icon(Icons.delete),
          ),
          ActionButton(
            icon: Icon(Icons.search),
          ),
          ActionButton(
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
