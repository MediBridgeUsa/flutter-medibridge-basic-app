import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String name;
  final String address;
  final String contactEmail;
  final Timestamp createdAt;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.contactEmail,
    required this.createdAt,
  });

  factory Company.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Company(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      contactEmail: data['contactEmail'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'contactEmail': contactEmail,
      'createdAt': createdAt,
    };
  }
}
