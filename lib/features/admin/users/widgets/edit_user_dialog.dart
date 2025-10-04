
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart'; // ¡Importante!
import 'package:myapp/features/admin/roles/role_model.dart';
import 'package:myapp/features/admin/roles/role_providers.dart';
import 'package:myapp/features/user/user_model.dart';

class EditUserDialog extends ConsumerStatefulWidget {
  final User user;

  const EditUserDialog({super.key, required this.user});

  @override
  ConsumerState<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<EditUserDialog> {
  late String? _selectedRoleId;
  late bool _isApproved;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.user.role;
    _isApproved = widget.user.isApproved;
  }

  // ¡MÉTODO DE GUARDADO COMPLETAMENTE REESCRITO!
  Future<void> _onSave() async {
    setState(() => _isLoading = true);

    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('setUserRole');
      
      await callable.call({
        'uid': widget.user.id,
        'role': _selectedRoleId,
        'isApproved': _isApproved,
      });
      
      if (mounted) {
        Navigator.of(context).pop(); // Cierra el diálogo de edición
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado con éxito.')),
        );
      }
    } on FirebaseFunctionsException catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
       }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsyncValue = ref.watch(rolesStreamProvider);

    return AlertDialog(
      title: Text('Editar Usuario: ${widget.user.displayName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Email: ${widget.user.email}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            
            // --- DROPDOWN DE ROLES ---
            rolesAsyncValue.when(
              data: (roles) {
                if (roles.isEmpty) {
                  return const Text('No hay roles disponibles.');
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedRoleId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Rol', border: OutlineInputBorder()),
                  items: roles.map((Role role) {
                    return DropdownMenuItem<String>(
                      value: role.id,
                      child: Text(role.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedRoleId = newValue);
                  },
                  validator: (value) => value == null ? 'Seleccione un rol.' : null,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error al cargar roles: $err'),
            ),
            const SizedBox(height: 20),
            
            // --- SWITCH DE APROBACIÓN ---
            SwitchListTile(
              title: const Text('Aprobado'),
              subtitle: Text(_isApproved ? 'El usuario tiene acceso' : 'El usuario no puede acceder'),
              value: _isApproved,
              onChanged: (bool value) {
                setState(() {
                  _isApproved = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _onSave,
          child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
