import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/google_auth_service.dart';
import 'auth/google_login_screen.dart';
import 'home/main_screen.dart';
import 'location/user_location_setup_screen.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final googleAuthService = GoogleAuthService();
    
    // Wait for splash screen animation (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    try {
      final user = await googleAuthService.loadSavedUser();
      
      if (user != null) {
        authProvider.setUser(user);
        
        // Check if user has set location
        await _checkUserLocation(user.id);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
        );
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
      );
    }
  }

  Future<void> _checkUserLocation(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLocation = prefs.getBool('userLocationSet') ?? false;
      
      if (!mounted) return;
      
      if (!hasLocation) {
        // Force user to set location first
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserLocationSetupScreen(isFirstTime: true),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // If error, go to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.primaryYellow,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'img/applogo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24),
              // App Title
              const Text(
                'INSTANT PICK',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
