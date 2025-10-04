import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/user/user_model.dart';

// Provider para el servicio de usuario
final userServiceProvider = Provider((ref) => UserService());

class UserService {
  final CollectionReference<User> _usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromFirestore(snapshot),
        toFirestore: (user, _) => user.toFirestore(),
      );

  // AÑADIDO: Obtener el DocumentSnapshot de un usuario. Requerido por AuthService.
  Future<DocumentSnapshot> getUserDocument(String uid) {
    return _usersCollection.doc(uid).get();
  }

  // Obtener un stream del perfil de un usuario específico
  Stream<User?> getUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  // Obtener un stream de TODOS los usuarios
  Stream<List<User>> getAllUsersStream() {
    return _usersCollection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => doc.data()).toList()
    );
  }

  // Crear el perfil de un usuario en Firestore
  Future<void> createUserProfile(User user) async {
    await _usersCollection.doc(user.id).set(user);
  }

  // Actualizar el perfil de un usuario
  Future<void> updateUserProfile(User user) async {
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }
}
