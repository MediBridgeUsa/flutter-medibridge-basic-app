import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/company/company_service.dart';
import 'package:myapp/features/company/company_model.dart';

// Provider para el CompanyService
final companyServiceProvider = Provider<CompanyService>((ref) => CompanyService());

// Provider que obtiene el stream de todas las compañías
final companyStreamProvider = StreamProvider<List<Company>>((ref) {
  final companyService = ref.watch(companyServiceProvider);
  return companyService.getCompanies();
});
