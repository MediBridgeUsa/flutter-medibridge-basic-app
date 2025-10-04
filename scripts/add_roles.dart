import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instance;

  final roles = ['Admin', 'Doctor', 'Patient'];

  for (final role in roles) {
    await firestore.collection('roles').doc(role).set({
      "name": role,
      "permissions": [],
    });
  }

  developer.log('Roles added successfully!', name: 'scripts.add_roles');
}
