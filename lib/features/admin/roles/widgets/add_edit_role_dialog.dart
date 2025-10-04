import 'package:flutter/material.dart';
import 'package:myapp/features/admin/roles/role_model.dart';

class AddEditRoleDialog extends StatefulWidget {
  final Role? role;

  const AddEditRoleDialog({super.key, this.role});

  @override
  State<AddEditRoleDialog> createState() => _AddEditRoleDialogState();
}

class _AddEditRoleDialogState extends State<AddEditRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _roleName;
  late String _roleDescription;
  late Map<String, Permissions> _permissionsByModule;

  // Lista predefinida de módulos para mantener la consistencia
  final List<String> _allModules = [
    'patients',
    'studies',
    'users',
    'roles',
    'appointments',
    'billing'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.role != null) {
      _roleName = widget.role!.name;
      _roleDescription = widget.role!.description;
      _permissionsByModule = Map.from(widget.role!.permissionsByModule);
    } else {
      _roleName = '';
      _roleDescription = '';
      _permissionsByModule = {};
    }

    // Asegurarse de que todos los módulos tengan una entrada
    for (final module in _allModules) {
      _permissionsByModule.putIfAbsent(
        module,
        () => Permissions(canRead: false, canCreate: false, canUpdate: false, canDelete: false),
      );
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newRole = Role(
        id: widget.role?.id ?? '', // El ID se manejará en la página principal
        name: _roleName,
        description: _roleDescription,
        isSystem: widget.role?.isSystem ?? false,
        version: widget.role?.version ?? 1,
        permissionsByModule: _permissionsByModule,
      );

      Navigator.of(context).pop(newRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.role == null ? 'Crear Nuevo Rol' : 'Editar Rol'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7, // Ancho del diálogo
          height: MediaQuery.of(context).size.height * 0.7, // Alto del diálogo
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _roleName,
                  decoration: const InputDecoration(labelText: 'Nombre del Rol'),
                  validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                  onSaved: (value) => _roleName = value!,
                  readOnly: widget.role?.isSystem ?? false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _roleDescription,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _roleDescription = value!,
                ),
                const SizedBox(height: 24),
                Text('Permisos por Módulo', style: Theme.of(context).textTheme.titleMedium),
                const Divider(),
                ..._allModules.map((module) {
                  final currentPerms = _permissionsByModule[module]!;
                  return Card(
                     margin: const EdgeInsets.symmetric(vertical: 8.0),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(module.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               _buildPermissionCheckbox('Leer', currentPerms.canRead, (val) => setState(() => _permissionsByModule[module] = currentPerms.copyWith(canRead: val))),
                               _buildPermissionCheckbox('Crear', currentPerms.canCreate, (val) => setState(() => _permissionsByModule[module] = currentPerms.copyWith(canCreate: val))),
                               _buildPermissionCheckbox('Actualizar', currentPerms.canUpdate, (val) => setState(() => _permissionsByModule[module] = currentPerms.copyWith(canUpdate: val))),
                               _buildPermissionCheckbox('Borrar', currentPerms.canDelete, (val) => setState(() => _permissionsByModule[module] = currentPerms.copyWith(canDelete: val))),
                             ],
                           ),
                         ],
                       ),
                     ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _onSave, child: const Text('Guardar')),
      ],
    );
  }

  Widget _buildPermissionCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        Checkbox(value: value, onChanged: onChanged),
      ],
    );
  }
}
