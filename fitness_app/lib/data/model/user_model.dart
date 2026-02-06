// Ficheiro: lib/data/model/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  UserModel({
    required super.uid,
    required super.email,
    super.name,
    super.photoUrl,
    super.createdAt,
  });

  // De Map (Firestore) para Model
  factory UserModel.fromMap(Map<String, dynamic> json, String documentId) {
    return UserModel(
      uid: documentId,
      email: json['email'] ?? '',
      name: json['name'],
      photoUrl: json['photo_url'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // De Model para Map (Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      // Se createdAt for null, o Firestore gera o timestamp no servidor
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}