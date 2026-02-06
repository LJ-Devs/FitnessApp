import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileViewModel extends ChangeNotifier {
  // State
  bool _isLoading = true;
  String _userName = "";
  String _joinDate = "";
  String? _avatarUrl; // null (no photo)

  String _appVersion = "";
  String get appVersion => _appVersion;

  // Getters
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get joinDate => _joinDate;
  String? get avatarUrl => _avatarUrl;

  ProfileViewModel() {
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = "v${packageInfo.version} (${packageInfo.buildNumber})";
      
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Load user data from Firestore
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          _userName = data['name'] ?? "Utilizador";
          _avatarUrl = data['photo_url'];

          if (_avatarUrl != null) {
            try {
              await NetworkImage(_avatarUrl!).evict();
            } catch (e) {
              // ignore cache errors, aren't critical
            }
          }

          // Read and format join date
          if (data['createdAt'] != null) {
            DateTime date;
            final dynamic createdAt = data['createdAt'];
            
            if (createdAt is Timestamp) {
              date = createdAt.toDate();
            } else if (createdAt is String) {
               date = DateTime.tryParse(createdAt) ?? DateTime.now();
            } else {
              date = DateTime.now();
            }

            _joinDate = "Membro desde ${_formatDate(date)}";
          } else {
            _joinDate = "";
          }
        } else {
          _userName = user.displayName ?? "Utilizador";
        }
      }
    } catch (e) {
      _userName = "Erro ao carregar";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Helper to format date
  String _formatDate(DateTime date) {
    const months = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"];
    return "${months[date.month - 1]} ${date.year}";
  }

  // Logout method
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}