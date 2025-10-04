import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/features/admin/roles/role_model.dart';
// La importación de Company era incorrecta. La eliminamos por ahora hasta que se cree el modelo.
// import 'package:myapp/features/company/company_model.dart';

/// Este script puebla la base de datos de Firestore con datos iniciales esenciales.
/// Incluye la creación de un conjunto completo de roles de usuario.
///
/// ¡ADVERTENCIA! La ejecución de este script sobrescribirá los datos existentes
/// para los roles con los IDs especificados.
Future<void> seedDatabase() async {
  final firestore = FirebaseFirestore.instance;

  try {
    debugPrint('Iniciando el sembrado de la base de datos...');

    // --- Crear Compañía por Defecto (SECCIÓN TEMPORALMENTE DESHABILITADA) ---
    // La lógica de la compañía se ha comentado hasta que el modelo y servicio
    // de 'Company' estén correctamente implementados y sin errores.
    /*
    final company = Company(
      id: 'medibridge', // ID Fijo para la compañía principal
      name: 'MediBridge Health Systems',
      address: '123 Health St, Wellness City, 45678',
      contactEmail: 'contact@medibridge.com',
      createdAt: Timestamp.now(),
    );
    await firestore.collection('companies').doc(company.id).set(company.toFirestore());
    debugPrint('Compañía "MediBridge" creada/actualizada exitosamente.');
    */

    // --- Crear Conjunto Completo de Roles ---
    final rolesCollection = firestore.collection('roles');
    final rolesToCreate = defineRoles();

    final WriteBatch batch = firestore.batch();
    for (final role in rolesToCreate) {
      final docRef = rolesCollection.doc(role.id);
      batch.set(docRef, role.toMap());
    }
    await batch.commit();
    debugPrint('${rolesToCreate.length} roles creados/actualizados exitosamente.');

    debugPrint('¡Sembrado de la base de datos completado!');

  } catch (e, stackTrace) {
    debugPrint('Error durante el sembrado de la base de datos: $e');
    debugPrint(stackTrace.toString());
  }
}

/// Define la lista de todos los roles de la aplicación con sus permisos específicos.
List<Role> defineRoles() {
  // Definiciones de permisos para reutilizar - CORREGIDO
  final noAccess = Permissions(canRead: false, canCreate: false, canUpdate: false, canDelete: false);
  final readOnly = Permissions(canRead: true, canCreate: false, canUpdate: false, canDelete: false);
  final readCreate = Permissions(canRead: true, canCreate: true, canUpdate: false, canDelete: false);
  final readUpdate = Permissions(canRead: true, canCreate: false, canUpdate: true, canDelete: false);
  final fullAccess = Permissions(canRead: true, canCreate: true, canUpdate: true, canDelete: true);

  return [
    // --- ROL 0: SUPERADMIN ---
    Role(
      id: 'superadmin',
      name: 'Super Administrador',
      description: 'Control total sobre todo el sistema, incluyendo la gestión de compañías.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': fullAccess,
        'studies': fullAccess,
        'users': fullAccess,
        'roles': fullAccess,
        'appointments': fullAccess,
        'billing': fullAccess,
        'companies': fullAccess,
      },
    ),

    // --- ROL 1: ADMINISTRADOR ---
    Role(
      id: 'admin',
      name: 'Administrador de Clínica',
      description: 'Acceso total a la gestión de una clínica, pero no puede crear/eliminar compañías.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': fullAccess,
        'studies': fullAccess,
        'users': readUpdate, // Puede leer y actualizar usuarios de su clínica
        'roles': readOnly, // Puede ver roles, pero no modificarlos
        'appointments': fullAccess,
        'billing': fullAccess,
        'companies': noAccess,
      },
    ),

    // --- ROL 2: MÉDICO ---
    Role(
      id: 'medico',
      name: 'Médico',
      description: 'Acceso a la información clínica de los pacientes y gestión de estudios.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': readOnly, // Puede ver la lista de pacientes
        'studies': readUpdate, // Puede ver y actualizar (ej. añadir informe) estudios
        'users': noAccess,
        'roles': noAccess,
        'appointments': readOnly, // Puede ver su agenda de citas
        'billing': noAccess,
        'companies': noAccess,
      },
    ),

    // --- ROL 3: RECEPCIONISTA ---
    Role(
      id: 'recepcionista',
      name: 'Recepcionista',
      description: 'Gestiona pacientes y citas.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': readCreate, // Puede registrar nuevos pacientes y verlos
        'studies': noAccess,
        'users': noAccess,
        'roles': noAccess,
        'appointments': readUpdate, // Puede gestionar todas las citas
        'billing': readOnly, // Puede consultar estado de facturación
        'companies': noAccess,
      },
    ),

    // --- ROL 4: FACTURACIÓN ---
    Role(
      id: 'facturacion',
      name: 'Personal de Facturación',
      description: 'Gestiona todos los aspectos de la facturación.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': readOnly,
        'studies': readOnly,
        'users': noAccess,
        'roles': noAccess,
        'appointments': readOnly,
        'billing': fullAccess, // Control total sobre la facturación
        'companies': noAccess,
      },
    ),

    // --- ROL 5: TÉCNICO ---
    Role(
      id: 'tecnico',
      name: 'Técnico de Laboratorio/Imagen',
      description: 'Realiza y sube los resultados de los estudios.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': readOnly, // Ve a qué paciente corresponde el estudio
        'studies': readCreate, // Puede crear nuevos estudios (subir resultados)
        'users': noAccess,
        'roles': noAccess,
        'appointments': readOnly, // Ve la lista de estudios a realizar
        'billing': noAccess,
        'companies': noAccess,
      },
    ),
    
    // --- ROL 6: PACIENTE ---
    Role(
      id: 'paciente',
      name: 'Paciente',
      description: 'Rol para usuarios que solo acceden a su propia información.',
      isSystem: true,
      version: 1,
      permissionsByModule: {
        'patients': readOnly, // Solo puede ver su propia información (lógica de UI requerida)
        'studies': readOnly, // Solo puede ver sus propios estudios
        'users': noAccess,
        'roles': noAccess,
        'appointments': readCreate, // Puede solicitar y ver sus propias citas
        'billing': readOnly, // Puede ver sus propias facturas
        'companies': noAccess,
      },
    ),
  ];
}
