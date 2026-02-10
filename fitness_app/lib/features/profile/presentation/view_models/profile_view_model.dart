import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class ProfileViewModel extends ChangeNotifier {
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ProfileViewModel({
    required this.logoutUseCase,
    required this.getProfileUseCase,
  }) {
    _listenToAuthChanges();
  }

  // State
  bool _isLoading = false;
  String _userName = "";
  String _joinDate = "";
  String? _avatarUrl;
  DateTime? _lastUpdateDate;
  String _appVersion = "";
  
  // Safety flag
  StreamSubscription? _authSubscription;
  bool _isDisposed = false;

  // Getters
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get joinDate => _joinDate;
  String get appVersion => _appVersion;

  String? get avatarUrl {
    if (_avatarUrl == null) return null;

    final version = _lastUpdateDate?.millisecondsSinceEpoch.toString();
    if (version != null) {
      return '$_avatarUrl?v=$version';
    }
    return _avatarUrl;
  }

  void _listenToAuthChanges() {
    _authSubscription = _firebaseAuth.userChanges().listen((user) {
      if (user != null) {
        loadUserProfile();
      }
    });
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    if (_isDisposed) return;

    _isLoading = true;
    notifyListeners();

    // App Version
    final packageInfo = await PackageInfo.fromPlatform();
    
    if (_isDisposed) return; // Safety check
    _appVersion = "v${packageInfo.version} (${packageInfo.buildNumber})";

    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Load user data from Firestore
      final result = await getProfileUseCase(user.uid);

      if (_isDisposed) return; // Safety check

      result.fold(
        (failure) {
           _userName = "Erro ao carregar";
        },
        (userEntity) {
           _userName = userEntity.name ?? "Utilizador";
           _avatarUrl = userEntity.photoUrl;
           _lastUpdateDate = userEntity.updatedAt;
           
           if (userEntity.createdAt != null) {
             _joinDate = "Membro desde ${_formatDate(userEntity.createdAt!)}";
           } else {
            _joinDate = "Membro desde...";
           }
        },
      );
    }
    
    if (!_isDisposed) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await logoutUseCase(NoParams());
  }

  // Helper to format date
  String _formatDate(DateTime date) {
    const months = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"];
    return "${months[date.month - 1]} ${date.year}";
  }

  @override
  void dispose() {
    _isDisposed = true;
    _authSubscription?.cancel();
    super.dispose();
  }
}