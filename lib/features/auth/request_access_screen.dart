
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/features/company/company_model.dart';
import 'package:myapp/features/company/company_providers.dart'; 
import 'package:myapp/features/admin/roles/role_model.dart';
import 'package:myapp/features/admin/roles/role_providers.dart';
import 'package:myapp/features/auth/auth_providers.dart';
import 'package:myapp/features/user/user_service.dart';
import 'package:myapp/features/user/user_model.dart';

// Providers para el estado del formulario
final selectedCompanyIdProvider = StateProvider<String?>((ref) => null);
final selectedRoleIdProvider = StateProvider<String?>((ref) => null);

class RequestAccessScreen extends ConsumerWidget {
  const RequestAccessScreen({super.key});

  void _submitRequest(BuildContext context, WidgetRef ref) async {
    final selectedCompanyId = ref.read(selectedCompanyIdProvider);
    final selectedRoleId = ref.read(selectedRoleIdProvider);
    final authState = ref.read(authStateChangesProvider);
    final userService = ref.read(userServiceProvider);

    if (selectedCompanyId == null || selectedRoleId == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona compañía y rol.')),
      );
      return;
    }

    final user = authState.value;
    if (user == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no autenticado.')),
      );
      return;
    }

    try {
      final updatedUser = User(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        role: selectedRoleId,
        companyId: selectedCompanyId,
        isApproved: false, 
      );

      await userService.updateUserProfile(updatedUser);
      
      if (!context.mounted) return;
      context.go('/');

    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsyncValue = ref.watch(companyStreamProvider);
    final rolesAsyncValue = ref.watch(rolesStreamProvider);

    final selectedCompanyId = ref.watch(selectedCompanyIdProvider);
    final selectedRoleId = ref.watch(selectedRoleIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Acceso'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Completa tu perfil',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona la compañía a la que perteneces y tu rol para solicitar acceso.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                companiesAsyncValue.when(
                  data: (companies) => DropdownButtonFormField<String>(
                    initialValue: selectedCompanyId,
                    decoration: const InputDecoration(labelText: 'Compañía', border: OutlineInputBorder()),
                    items: companies.map((Company company) {
                      return DropdownMenuItem(value: company.id, child: Text(company.name));
                    }).toList(),
                    onChanged: (value) => ref.read(selectedCompanyIdProvider.notifier).state = value,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error al cargar compañías: $err'),
                ),
                const SizedBox(height: 24),

                rolesAsyncValue.when(
                  data: (roles) => DropdownButtonFormField<String>(
                    initialValue: selectedRoleId,
                    decoration: const InputDecoration(labelText: 'Rol', border: OutlineInputBorder()),
                    items: roles.map((Role role) {
                      return DropdownMenuItem(value: role.id, child: Text(role.name));
                    }).toList(),
                    onChanged: (value) => ref.read(selectedRoleIdProvider.notifier).state = value,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error al cargar roles: $err'),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () => _submitRequest(context, ref),
                  child: const Text('Enviar Solicitud'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
