import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:myapp/features/auth/auth_exceptions.dart';
import 'package:myapp/features/user/user_model.dart';
import 'package:myapp/features/user/user_service.dart';

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final UserService _userService = UserService(); // Usamos nuestro servicio de usuario

  Stream<firebase.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ¡AÑADIDO! Método para obtener el documento del usuario desde el UserService
  Future<DocumentSnapshot> getUserDocument(String uid) {
    return _userService.getUserDocument(uid);
  }

  Future<firebase.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw InvalidCredentialsException();
      }
      throw GenericAuthException();
    }
  }

  Future<firebase.User?> createUserWithEmailAndPassword(
      {required String email, required String password, required String displayName}) async {
    try {
      // 1. Crear el usuario en Firebase Authentication
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        // Actualizar el perfil de Firebase Auth con el nombre
        await firebaseUser.updateDisplayName(displayName);

        // 2. Crear nuestro objeto de usuario de la aplicación
        final newUser = User(
          id: firebaseUser.uid,
          email: email,
          displayName: displayName,
          role: 'paciente', // Asignamos el rol por defecto "paciente"
          companyId: null, // Sin compañía al registrarse
        );

        // 3. Guardar el perfil de usuario en Firestore usando nuestro UserService
        await _userService.createUserProfile(newUser);
      }
      return firebaseUser;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordException();
      }
      throw GenericAuthException();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      }
      throw GenericAuthException();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      // No es crítico manejar el error aquí
    }
  }
 
  Future<bool> isAdmin() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;

    try {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims?['admin'] == true;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw RequiresRecentLoginException();
      }
      return false;
    }
  }
}
