import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/user_model.dart';

// Contract
abstract class ProfileRemoteDataSource {
  Future<String> uploadProfileImage(File imageFile, String uid);
  Future<void> updateUserData({required String uid, required String name, String? photoUrl});
  Future<UserModel> getUserProfile(String uid);
}

// Implementation
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ProfileRemoteDataSourceImpl({
    required this.firebaseStorage,
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    final ref = firebaseStorage.ref().child('users/$uid/profile.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  @override
  Future<void> updateUserData({required String uid, required String name, String? photoUrl}) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
    }

    await firebaseFirestore.collection('users').doc(uid).set({
      'name': name,
      if (photoUrl != null) 'photo_url': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<UserModel> getUserProfile(String uid) async {
    try {
      // Try to read from Firestore
      // Verify cache and then server
      final doc = await firebaseFirestore.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      } 
      
      // Use Auth as fallback
      final user = firebaseAuth.currentUser;
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      
      throw Exception("User not found");
    } catch (e) {
      // No conextion no cache
      final user = firebaseAuth.currentUser;
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      rethrow;
    }
  }
}