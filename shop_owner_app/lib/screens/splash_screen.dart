import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/user_provider.dart';
import 'shop/shop_registration_screen.dart';
import 'home/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Load saved username
    await userProvider.loadUsername();
    
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      if (userProvider.hasUsername) {
        // User has shop registered, go to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // No shop registered, show registration screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ShopRegistrationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryIndigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkIndigo.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.store,
                size: 60,
                color: AppTheme.primaryIndigo,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Shop Owner Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage Your Business',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
            ),
          ],
        ),
      ),
    );
  }
}