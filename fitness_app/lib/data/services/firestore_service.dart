import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save data
  Future<void> saveUser(AppUser user) async {
    try {
      // Create/Update document at DB -> ID = uid
      await _db.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow; // rethrow the error to solve
    }
  }
  
  // Optional method to read data
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}