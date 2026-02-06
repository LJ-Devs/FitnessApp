import 'package:flutter/material.dart';
import '../ui/auth/pages/login_page.dart';
import '../ui/auth/pages/register_page.dart';
import '../ui/home/pages/home_page.dart';
import '../ui/profile/pages/edit_profile_page.dart';

class AppRoutes {
  // Constant do avoid errors
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