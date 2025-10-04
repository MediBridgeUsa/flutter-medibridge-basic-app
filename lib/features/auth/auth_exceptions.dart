
/// Clase base para todas las excepciones de autenticación.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

// --- Excepciones de Inicio de Sesión ---

/// Lanzada cuando las credenciales (email/contraseña) no son válidas.
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Correo electrónico o contraseña incorrectos.');
}

/// Lanzada cuando se intenta iniciar sesión con un usuario que no existe.
class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('No se encontró un usuario con ese correo electrónico.');
}

// --- Excepciones de Registro ---

/// Lanzada cuando se intenta registrar un correo que ya está en uso.
class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Este correo electrónico ya está registrado.');
}

/// Lanzada cuando la contraseña proporcionada es demasiado débil.
class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('La contraseña es demasiado débil. Debe tener al menos 6 caracteres.');
}

// --- Excepciones Generales ---

/// Lanzada cuando la operación requiere que el usuario haya iniciado sesión recientemente.
class RequiresRecentLoginException extends AuthException {
  RequiresRecentLoginException() : super('Esta operación es sensible y requiere una autenticación reciente. Vuelve a iniciar sesión.');
}

/// Una excepción genérica para cualquier otro error de autenticación no manejado específicamente.
class GenericAuthException extends AuthException {
  GenericAuthException() : super('Ocurrió un error de autenticación inesperado. Inténtalo de nuevo.');
}
