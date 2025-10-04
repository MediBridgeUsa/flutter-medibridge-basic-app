import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/admin/roles/role_model.dart';
import 'package:myapp/features/admin/roles/role_providers.dart';
import 'package:myapp/features/admin/roles/widgets/add_edit_role_dialog.dart';

// El stream provider ahora usa el método correcto: getRoles()
final rolesStreamProvider = StreamProvider.autoDispose<List<Role>>((ref) {
  final roleService = ref.watch(roleServiceProvider);
  return roleService.getRoles(); // ¡CORREGIDO!
});

class RoleManagementPage extends ConsumerWidget {
  const RoleManagementPage({super.key});

  void _openAddEditRoleDialog(BuildContext context, WidgetRef ref, [Role? role]) async {
    final result = await showDialog<Role>(
      context: context,
      builder: (context) => AddEditRoleDialog(role: role),
    );

    if (result == null) return;

    final roleService = ref.read(roleServiceProvider);

    try {
      String action;
      if (role == null) {
        // Generar un ID basado en el nombre para nuevos roles
        final newId = result.name.replaceAll(' ', '_').toLowerCase();
        final roleToCreate = result.copyWith(id: newId);
        await roleService.addRole(roleToCreate);
        action = 'creado';
      } else {
        await roleService.updateRole(result);
        action = 'actualizado';
      }

      if (!context.mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol "${result.name}" $action correctamente.')),
      );

    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el rol: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsyncValue = ref.watch(rolesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Roles')),
      body: rolesAsyncValue.when(
        data: (roles) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // Espacio para el FAB
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(role.name, style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text(role.description),
                trailing: role.isSystem
                    ? const Chip(label: Text('Sistema'), backgroundColor: Colors.blueGrey)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Editar Rol',
                            onPressed: () => _openAddEditRoleDialog(context, ref, role),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Eliminar Rol',
                            onPressed: () async {
                              // Añadir diálogo de confirmación antes de borrar
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar Eliminación'),
                                  content: Text('¿Estás seguro de que quieres eliminar el rol "${role.name}"?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ) ?? false;

                              if (confirm) {
                                 try {
                                    await ref.read(roleServiceProvider).deleteRole(role.id);
                                    if (!context.mounted) return;
                                     ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Rol "${role.name}" eliminado.')),
                                    );
                                 } catch(e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al eliminar el rol: $e')),
                                    );
                                 }
                              }
                            },
                          ),
                        ],
                      ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildPermissionsDisplay(context, role.permissionsByModule),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error al cargar roles: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditRoleDialog(context, ref),
        tooltip: 'Crear Nuevo Rol',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPermissionsDisplay(BuildContext context, Map<String, Permissions> permissions) {
    final modules = permissions.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Permisos Detallados', style: Theme.of(context).textTheme.titleMedium),
        const Divider(),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          border: TableBorder.all(color: Colors.grey.shade300, width: 1),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.black12),
              children: [
                Padding(padding: const EdgeInsets.all(8.0), child: Text('Módulo', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text('Leer', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text('Crear', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text('Actualizar', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text('Borrar', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            ...modules.map((module) {
              final perms = permissions[module]!;
              return TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0), child: Text(module.toUpperCase())),
                  Center(child: _permissionIcon(perms.canRead)),
                  Center(child: _permissionIcon(perms.canCreate)),
                  Center(child: _permissionIcon(perms.canUpdate)),
                  Center(child: _permissionIcon(perms.canDelete)),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _permissionIcon(bool granted) {
    return Icon(
      granted ? Icons.check_circle : Icons.cancel,
      color: granted ? Colors.green.shade600 : Colors.red.shade600,
      size: 20,
    );
  }
}
