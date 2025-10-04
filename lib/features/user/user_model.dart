
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de usuario unificado para toda la aplicación.
class User {
  final String id; // Corresponde al UID de Firebase Auth
  final String displayName;
  final String email;
  final String? role; // ID del rol asignado al usuario
  final String? companyId; // Opcional: ID de la compañía a la que pertenece
  final bool isApproved; // CAMBIADO: De String? status a bool isApproved

  User({
    required this.id,
    required this.displayName,
    required this.email,
    this.role,
    this.companyId,
    this.isApproved = false, // CAMBIADO: Valor por defecto es false
  });

  // Crea una copia de la instancia con los campos dados reemplazados
  User copyWith({
    String? id,
    String? displayName,
    String? email,
    String? role,
    String? companyId,
    bool? isApproved, // CAMBIADO a bool?
    bool allowNullCompanyId = false,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      companyId: allowNullCompanyId ? companyId : companyId ?? this.companyId,
      isApproved: isApproved ?? this.isApproved, // CAMBIADO
    );
  }

  // Fábrica para crear un objeto User desde un DocumentSnapshot de Firestore.
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] as String?,
      companyId: data['companyId'] as String?,
      // CAMBIADO: Lee el booleano 'isApproved', con fallback a false si no existe.
      isApproved: data['isApproved'] as bool? ?? false, 
    );
  }

  // Convierte el objeto User a un mapa para guardarlo en Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'isApproved': isApproved, // CAMBIADO
      if (role != null) 'role': role,
      if (companyId != null) 'companyId': companyId,
    };
  }
}
