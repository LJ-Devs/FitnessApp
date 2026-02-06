import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Uploads a profile image and returns its download URL
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    try {
      // Define storage reference path UserId/profile.jpg
      final ref = _storage.ref().child('users/$uid/profile.jpg');

      // Upload file
      await ref.putFile(imageFile);

      // Get download URL to save in user profile
      final url = await ref.getDownloadURL();
      return url;
      
    } catch (e) {
      throw Exception('Falha no upload da imagem: $e');
    }
  }
}