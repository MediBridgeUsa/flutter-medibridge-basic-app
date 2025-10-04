import 'dart:convert';
import 'dart:io';
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
  final rolesCollection = firestore.collection("roles");

  final file = File("seeds/roles_seed.json");
  if (!await file.exists()) {
    developer.log("Error: seeds/roles_seed.json not found!", name: 'scripts.seed_roles');
    return;
  }

  final content = await file.readAsString();
  final data = json.decode(content);

  final roles = data["roles"] as List;

  developer.log("Starting to seed roles...", name: 'scripts.seed_roles');

  for (final roleData in roles) {
    final roleName = roleData["name"];
    if (roleName != null) {
      await rolesCollection.doc(roleName).set(roleData);
      developer.log("Uploaded role: $roleName", name: 'scripts.seed_roles');
    }
  }

  developer.log("Seeding complete!", name: 'scripts.seed_roles');
}
