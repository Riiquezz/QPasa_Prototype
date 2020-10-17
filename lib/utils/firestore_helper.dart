import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final _firestore = FirebaseFirestore.instance;

  Future getSingleDocument(String collection, String document) async {
    return await _firestore.collection(collection).doc(document).get();
  }

  getDataWhereEqual(String collection, String field, dynamic condition) {
    return _firestore
        .collection(collection)
        .where(field, isEqualTo: condition)
        .snapshots();
  }

  getDocuments(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  setNewDocument(String collection, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collection).add(data);
  }

  getLastDocument(String collection, String field) {
    return _firestore
        .collection(collection)
        .orderBy(field, descending: true)
        .limit(1)
        .get();
  }
}
