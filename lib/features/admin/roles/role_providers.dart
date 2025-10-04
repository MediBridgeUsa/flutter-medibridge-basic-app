import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/admin/roles/role_service.dart';
import 'package:myapp/features/admin/roles/role_model.dart'; // Movido aquí

// Provider único para el RoleService
final roleServiceProvider = Provider<RoleService>((ref) => RoleService());

// Provider que obtiene el stream de todos los roles.
final rolesStreamProvider = StreamProvider<List<Role>>((ref) {
  // Escucha al roleServiceProvider para obtener la instancia del servicio
  final roleService = ref.watch(roleServiceProvider);
  // Llama al método getRoles que ahora sí existe y devuelve el stream.
  return roleService.getRoles();
});

// Provider que obtiene el stream de un único rol por su ID.
final roleByIdStreamProvider = StreamProvider.family<Role?, String>((ref, roleId) {
  final roleService = ref.watch(roleServiceProvider);
  // Llama al método getRoleById que acabamos de añadir.
  return roleService.getRoleById(roleId);
});
