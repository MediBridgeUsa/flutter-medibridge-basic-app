import 'dart:convert';

/// Modelo para los permisos dentro de cada módulo.
/// Utiliza un esquema de nombres más claro como `canRead`, `canCreate`, etc.
class Permissions {
  final bool canRead;
  final bool canCreate;
  final bool canUpdate;
  final bool canDelete;

  Permissions({
    required this.canRead,
    required this.canCreate,
    required this.canUpdate,
    required this.canDelete,
  });

  // Método para crear una copia del objeto con valores modificados
  Permissions copyWith({
    bool? canRead,
    bool? canCreate,
    bool? canUpdate,
    bool? canDelete,
  }) {
    return Permissions(
      canRead: canRead ?? this.canRead,
      canCreate: canCreate ?? this.canCreate,
      canUpdate: canUpdate ?? this.canUpdate,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  // Deserialización: Crea un objeto Permissions desde un mapa (ej. de Firestore)
  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      canRead: map['canRead'] ?? false,
      canCreate: map['canCreate'] ?? false,
      canUpdate: map['canUpdate'] ?? false,
      canDelete: map['canDelete'] ?? false,
    );
  }

  // Serialización: Convierte el objeto Permissions a un mapa para guardarlo
  Map<String, dynamic> toMap() {
    return {
      'canRead': canRead,
      'canCreate': canCreate,
      'canUpdate': canUpdate,
      'canDelete': canDelete,
    };
  }

  factory Permissions.fromJson(String source) =>
      Permissions.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

/// Modelo principal para el Rol.
class Role {
  final String id;
  final String name;
  final String description;
  final bool isSystem;
  final int version;
  final Map<String, Permissions> permissionsByModule;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.isSystem,
    required this.version,
    required this.permissionsByModule,
  });

  // Método para crear una copia del objeto con valores modificados
  Role copyWith({
    String? id,
    String? name,
    String? description,
    bool? isSystem,
    int? version,
    Map<String, Permissions>? permissionsByModule,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isSystem: isSystem ?? this.isSystem,
      version: version ?? this.version,
      permissionsByModule: permissionsByModule ?? this.permissionsByModule,
    );
  }

  // Deserialización desde Firestore
  factory Role.fromMap(Map<String, dynamic> map, String documentId) {
    return Role(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isSystem: map['isSystem'] ?? false,
      version: map['version'] ?? 1,
      permissionsByModule: (map['permissionsByModule'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, Permissions.fromMap(value as Map<String, dynamic>)),
          ) ??
          {},
    );
  }

  // Serialización para Firestore
  Map<String, dynamic> toMap() {
    // No incluimos el 'id' aquí porque es el ID del documento, no un campo.
    return {
      'name': name,
      'description': description,
      'isSystem': isSystem,
      'version': version,
      'permissionsByModule': permissionsByModule.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    };
  }

 factory Role.fromJson(String source, String documentId) =>
      Role.fromMap(json.decode(source), documentId);

  String toJson() => json.encode(toMap());

}
