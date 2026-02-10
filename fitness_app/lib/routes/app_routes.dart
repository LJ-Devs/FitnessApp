import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';

class AppRoutes {
  // Constant to avoid errors
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String editProfile = '/edit-profile';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    home: (context) => const HomePage(),
    editProfile: (context) => const EditProfilePage(),
  };
}