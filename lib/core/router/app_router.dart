import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/auth_wrapper.dart';
import 'package:myapp/features/auth/login_page.dart';
// Importación actualizada
import 'package:myapp/features/auth/signup_page.dart';
import 'package:myapp/features/auth/forgot_password_screen.dart';
import 'package:myapp/features/dashboard/dashboard_screen.dart'; // Importa DashboardScreen
import 'package:myapp/features/profile/profile_screen.dart';
import 'package:myapp/features/patients/patient_list_page.dart';
import 'package:myapp/features/admin/roles/role_management_page.dart';

// Nueva pantalla para la solicitud de acceso
import 'package:myapp/features/auth/request_access_screen.dart';
import 'package:myapp/core/setup/developer_tools_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (context, state) => const AuthWrapper(),
          routes: [
            // La ruta '/' ahora está gestionada por AuthWrapper,
            // que internamente muestra DashboardScreen o LoginPage.
          ]),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/patients',
        builder: (context, state) => const PatientListPage(),
      ),
      GoRoute(
        path: '/admin/roles',
        builder: (context, state) => const RoleManagementPage(),
      ),
      // Nueva ruta para la solicitud de acceso
      GoRoute(
        path: '/request-access',
        builder: (context, state) => const RequestAccessScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        // Referencia a la clase actualizada
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Ruta para herramientas de desarrollador, solo disponible en modo debug
      if (kDebugMode)
        GoRoute(
          path: '/dev-tools',
          builder: (context, state) => const DeveloperToolsPage(),
        ),
    ],
  );
}
