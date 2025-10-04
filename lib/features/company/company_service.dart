import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/company/company_model.dart';

class CompanyService {
  final CollectionReference<Company> _companiesCollection = 
      FirebaseFirestore.instance.collection('companies').withConverter<Company>(
        fromFirestore: (snapshot, _) => Company.fromFirestore(snapshot),
        toFirestore: (company, _) => company.toFirestore(),
      );

  Stream<List<Company>> getCompanies() {
    return _companiesCollection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => doc.data()).toList()
    );
  }
}
