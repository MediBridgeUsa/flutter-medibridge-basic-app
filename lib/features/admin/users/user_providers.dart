import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/user/user_model.dart';      // Ruta correcta
import 'package:myapp/features/user/user_service.dart';    // Ruta correcta

// Provider que expone un stream de la lista completa de usuarios.
// Ideal para la vista de administrador.
final usersStreamProvider = StreamProvider<List<User>>((ref) {
  // Obtenemos la instancia de UserService, que ya tiene su propio provider
  // en user_service.dart, pero lo volvemos a llamar aquí para la dependencia.
  final userService = ref.watch(userServiceProvider);
  return userService.getAllUsersStream(); // Necesitaremos añadir este método al servicio.
});

// Provider para obtener un usuario específico por su ID
final userProvider = StreamProvider.family<User?, String>((ref, userId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserProfile(userId); // Este método ya existe.
});
