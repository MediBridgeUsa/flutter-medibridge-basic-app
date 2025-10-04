# MediBridge - Plan de Desarrollo

## Descripción General

MediBridge es una aplicación integral de RIS/PACS (Sistema de Información Radiológica/Sistema de Comunicación y Archivo de Imágenes) diseñada para optimizar los flujos de trabajo en radiología. Este documento describe la arquitectura, las características y los principios de diseño de la aplicación.

## Funcionalidades Implementadas (hasta el análisis inicial)

### Estructura Principal
- **Framework:** Flutter
- **Gestión de Estado:** Riverpod
- **Enrutamiento:** GoRouter
- **Backend:** Firebase (Authentication, Firestore)

### Autenticación
- Existe un `AuthWrapper` para redirigir a los usuarios según su estado de autenticación.
- La `LoginPage` es un placeholder sin funcionalidad.
- Las dependencias para inicio de sesión con Google y Apple están incluidas.

### Navegación
- La ruta raíz `/` dirige al `AuthWrapper`.
- Las rutas para `/patients` y `/admin/roles` están definidas, pero su contenido aún no se ha revisado.

## Plan Actual: Reconstrucción de la Autenticación

El objetivo inmediato es construir un sistema de autenticación robusto y seguro. La aplicación no es funcional actualmente debido al flujo de autenticación incompleto.

### Etapa 1: Autenticación

1.  **Implementar UI:**
    *   **Pantalla de Login (`login_page.dart`):**
        *   Campos de entrada para email y contraseña.
        *   Botón "Iniciar Sesión" con indicadores de carga y error.
        *   Enlace "¿Olvidaste tu contraseña?".
        *   Enlace de navegación a la pantalla de Registro.
        *   Botones de inicio de sesión social (Google y Apple).
    *   **Pantalla de Registro (`signup_page.dart`):**
        *   Campos para email, contraseña y confirmación de contraseña.
        *   Botón "Registrarse" con validación.
        *   Enlace de navegación a la pantalla de Login.
    *   **Pantalla de Olvidé Contraseña (`forgot_password_screen.dart`):**
        *   Campo de entrada para email.
        *   Botón "Enviar correo de restablecimiento".
    *   **Pantalla de Perfil (`profile_screen.dart`):**
        *   Mostrar información del usuario (email, nombre).
        *   Botón "Cerrar Sesión".

2.  **Implementar Lógica:**
    *   **`AuthService` (`auth_service.dart`):**
        *   Implementar `signInWithEmailAndPassword`.
        *   Implementar `createUserWithEmailAndPassword`.
        *   Implementar `signInWithGoogle`.
        *   Implementar `signInWithApple`.
        *   Implementar `sendPasswordResetEmail`.
        *   Implementar `signOut`.
    *   **`UserProvider` (`user_provider.dart`):**
        *   Escuchar los cambios de `FirebaseAuth.instance.authStateChanges()`.
        *   Al iniciar sesión, obtener el perfil de usuario correspondiente de la colección "users" en Firestore.
        *   Al crear un usuario, crear un nuevo documento en la colección "users".
        *   Proveer el objeto de usuario (o nulo si no está autenticado) al resto de la aplicación.

3.  **Actualizar Navegación (`app_router.dart`):**
    *   Añadir rutas: `/login`, `/signup`, `/forgot-password`, `/profile`.
    *   Asegurar que el enrutador maneje correctamente las redirecciones y proteja las rutas que requieren autenticación.

### Etapa 2: Roles y Permisos de Usuario

*Esta etapa comenzará después de que la autenticación sea completamente funcional.*

- Analizar `role_management_page.dart` y `admin_roles_page.dart` existentes.
- Diseñar un sistema de control de acceso basado en roles (RBAC) flexible utilizando Firebase custom claims y Firestore.
- Definir roles por defecto (ej. Administrador, Radiólogo, Técnico).
- Crear una interfaz de usuario para gestionar roles y asignarlos a los usuarios.

### Etapa 3: UI/UX del Panel de Administración

*Esta etapa seguirá a la implementación de roles y permisos.*

- Rediseñar e implementar los paneles de administración para la gestión de usuarios y roles (`/admin/users`, `/admin/roles`).
- Asegurar que la interfaz de usuario sea intuitiva y proporcione todas las funcionalidades necesarias para los administradores.