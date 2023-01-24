import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> addDocumentWithId(String id, Map data) {
    return ref.doc(id).set(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }

  Future<QuerySnapshot> getWhere(String key, String value) {
    return ref.where(key, isEqualTo: value).get();
  }

  Future<QuerySnapshot> getWhereWhere(String key1, String value1,String key2, String value2) {
    return ref.where(key1, isEqualTo: value1).where(key2, isEqualTo: value2).get();
  }

  Future<QuerySnapshot> orderBy(String key) {
    return ref
        .orderBy(
          key,
          descending: true
        )
        .get();
  }
}
