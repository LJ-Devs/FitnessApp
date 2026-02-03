import 'package:flutter/material.dart';
import '../../core/themes/tenant.dart';
import '../../home/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Time Simulation
    await Future.delayed(const Duration(seconds: 2));

    // AuthProvider here
    // if logged -> HomePage
    // else -> LoginPage
    
    // Como ainda não temos LoginPage, vamos diretos para a Home:
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Option A
      backgroundColor: tenant.mainColor, 
      // Option B
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Image from Tenant here. Text example now  ---> Image.asset(tenant.logoPath)
            const Icon(Icons.fitness_center, size: 80, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              tenant.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // Loading circle 
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}