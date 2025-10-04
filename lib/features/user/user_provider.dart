import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/user/user_model.dart' as um;
import 'package:myapp/features/user/user_service.dart';

// Provider que devuelve el estado de autenticación de Firebase
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider.family que, basado en un UID, obtiene el perfil de usuario de Firestore
final userProfileProvider = StreamProvider.family<um.User?, String>((ref, String uid) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserProfile(uid);
});
