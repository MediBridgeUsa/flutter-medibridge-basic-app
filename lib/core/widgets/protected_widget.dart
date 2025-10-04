
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/auth_providers.dart';
import 'package:myapp/features/admin/roles/role_providers.dart';
import 'package:myapp/features/admin/roles/role_model.dart';

class ProtectedWidget extends ConsumerWidget {
  final String permission;
  final Widget child;

  const ProtectedWidget({super.key, required this.permission, required this.child});

  bool _hasPermission(Role role, String permission) {
    final parts = permission.split('.');
    if (parts.length != 2) {
      return false; // El formato del permiso es inválido
    }
    final module = parts[0];
    final action = parts[1];

    final modulePermissions = role.permissionsByModule[module];
    if (modulePermissions == null) {
      return false; // El módulo no existe en los permisos del rol
    }

    switch (action) {
      case 'create':
        return modulePermissions.canCreate;
      case 'read':
        return modulePermissions.canRead;
      case 'update':
        return modulePermissions.canUpdate;
      case 'delete':
        return modulePermissions.canDelete;
      default:
        return false; // La acción no es válida
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleId = ref.watch(userRoleProvider);

    if (userRoleId == null) {
      return const SizedBox.shrink();
    }

    final roleStream = ref.watch(roleByIdStreamProvider(userRoleId));

    return roleStream.when(
      data: (role) {
        if (role == null || !_hasPermission(role, permission)) {
          return const SizedBox.shrink();
        }
        return child;
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
