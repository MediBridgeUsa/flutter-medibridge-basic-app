
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/auth/auth_service.dart';

// Provider for the AuthService instance
final authServiceInstanceProvider = Provider<AuthService>((ref) => AuthService());

// State Notifier Provider for authentication logic
final authServiceProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Initially, no user is logged in. 
    // The auth state will be determined by authStateChangesProvider.
    return null;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceInstanceProvider).signInWithEmailAndPassword(email, password),
    );
  }

  Future<void> createUserWithEmailAndPassword({required String email, required String password, required String displayName}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceInstanceProvider).createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // No need to change the global auth state for this action
    await ref.read(authServiceInstanceProvider).sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      // ¡CORREGIDO! Error de tipeo.
      await ref.read(authServiceInstanceProvider).signOut();
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

// Provider to stream authentication state changes from Firebase
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceInstanceProvider).authStateChanges;
});

// Provider for the user profile data from Firestore
// Este provider ahora depende del estado de autenticación real
final userProfileProvider = StreamProvider<DocumentSnapshot?>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        // ¡CORREGIDO! Ahora AuthService tiene este método.
        return ref.watch(authServiceInstanceProvider).getUserDocument(user.uid).asStream();
      }
      return Stream.value(null); // No user, no profile
    },
    loading: () => Stream.value(null), // Still loading auth state
    error: (_, _) => Stream.value(null), // Error in auth state
  );
});

// Provider para obtener el rol del usuario actual
final userRoleProvider = Provider<String?>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  return userProfile.when(
    data: (snapshot) {
      if (snapshot != null && snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // Asumimos que el campo que guarda el ID del rol se llama 'role'
        return data['role'] as String?;
      }
      return null;
    },
    loading: () => null,
    error: (_, _) => null,
  );
});
