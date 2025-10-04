import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/protected_widget.dart'; // ¡RUTA CORREGIDA!

class PatientListPage extends StatelessWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pacientes'),
      ),
      body: const Center(
        child: Text('Aquí se mostrará la lista de pacientes.'),
      ),
      // Usamos ProtectedWidget para el botón de añadir
      floatingActionButton: ProtectedWidget(
        permission: 'pacientes.create', // Solo visible si tiene este permiso
        child: FloatingActionButton(
          onPressed: () {
            // Lógica para añadir un nuevo paciente
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Acción de crear paciente permitida.')),
            );
          },
          tooltip: 'Añadir Paciente',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
