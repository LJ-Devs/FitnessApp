import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// Contract (Interface)
abstract class ProfileRemoteDataSource {
  Future<String> uploadProfileImage(File imageFile, String uid);
}

// Implementation
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  // Dependency Injection
  ProfileRemoteDataSourceImpl({required this.firebaseStorage});

  @override
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    try {
      // Define path: users/{uid}/profile.jpg
      // This overwrites the previous image, is good for saving space.
      final ref = firebaseStorage.ref().child('users/$uid/profile.jpg');

      // Upload file
      await ref.putFile(imageFile);

      // Get and return the URL
      final url = await ref.getDownloadURL();
      return url;
      
    } catch (e) {
      // Throw a generic exception here
      throw Exception('Failed to upload image: $e');
    }
  }
}