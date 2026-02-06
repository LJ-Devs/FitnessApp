import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save or update a generic document
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).set(data, SetOptions(merge: true));
  }

  // Get a document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collection, String docId) async {
    return await _db.collection(collection).doc(docId).get();
  }
  
  // Update specific fields in a document
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }
}