import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/admin/roles/role_model.dart';

class RoleService {
  final CollectionReference<Role> _rolesCollection = 
      FirebaseFirestore.instance.collection('roles').withConverter<Role>(
        fromFirestore: (snapshot, _) => Role.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (role, _) => role.toMap(),
      );

  // Obtener un stream de todos los roles (nombre corregido)
  Stream<List<Role>> getRoles() {
    return _rolesCollection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => doc.data()).toList()
    );
  }

  // Obtener un stream de un único rol por su ID (método añadido)
  Stream<Role?> getRoleById(String roleId) {
    return _rolesCollection.doc(roleId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    });
  }

  // Añadir un nuevo rol
  Future<void> addRole(Role role) async {
    // Usamos el ID del rol como ID del documento
    await _rolesCollection.doc(role.id).set(role);
  }

  // Actualizar un rol existente
  Future<void> updateRole(Role role) async {
    await _rolesCollection.doc(role.id).update(role.toMap());
  }

  // Eliminar un rol
  Future<void> deleteRole(String roleId) async {
    await _rolesCollection.doc(roleId).delete();
  }
}
