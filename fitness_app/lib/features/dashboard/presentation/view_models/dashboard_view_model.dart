import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';

class DashboardViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  DashboardViewModel({required this.getProfileUseCase}) {
    _listenToAuthChanges();
  }

  String _greetingName = 'Atleta';
  String? _avatarUrl;
  bool _isLoading = false;
  StreamSubscription? _authSubscription;

  String get greetingName => _greetingName;
  String? get avatarUrl => _avatarUrl;
  bool get isLoading => _isLoading;

  // Safety cheack
  bool _isDisposed = false;

  void _listenToAuthChanges() {
    _authSubscription = _firebaseAuth.userChanges().listen((user) {
      if (_isDisposed) return;

      if (user != null) {
        loadUserInfo();
      }
    });
  }

  Future<void> loadUserInfo() async {
    if (_isDisposed) return;

    final user = _firebaseAuth.currentUser;

    if (user != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_isDisposed) return;
      _isLoading = true;
      notifyListeners();

      final result = await getProfileUseCase(user.uid);

      if (_isDisposed) return;

      result.fold(
        (failure) {
          debugPrint("Erro ao carregar nome no dashboard: ${failure.message}");
        },
        (userEntity) {
          if (userEntity.name != null && userEntity.name!.isNotEmpty) {
            // Extract only the first name
            _greetingName = userEntity.name!.split(' ').first;
          }
          _avatarUrl = userEntity.photoUrl;
        },
      );

      _isLoading = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _authSubscription?.cancel();
    super.dispose();
  }
}