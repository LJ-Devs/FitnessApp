import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? name;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.createdAt,
  });

  // AppUser -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Json -> AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    DateTime? date;
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Timestamp) {
        date = (json['createdAt'] as Timestamp).toDate();
      } else if (json['createdAt'] is String) {
        date = DateTime.tryParse(json['createdAt']);
      }
    }
    return AppUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      createdAt: date,
    );
  }
}