import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('🔥 Testing Firebase connection...');
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('✅ Firebase initialized successfully!');
    
    // Test Firebase Auth
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth instance created');
    print('📱 Current user: ${auth.currentUser?.uid ?? 'None'}');
    
    // Test phone verification (without actually sending SMS)
    print('🔥 Testing phone verification setup...');
    
    // This will test if the configuration is correct without sending SMS
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+1234567890', // Fake number for testing
        verificationCompleted: (credential) {
          print('✅ Verification completed callback works');
        },
        verificationFailed: (exception) {
          print('⚠️  Verification failed (expected for fake number): ${exception.code}');
          if (exception.code == 'invalid-phone-number') {
            print('✅ Firebase is properly configured (invalid number detected)');
          } else if (exception.code == 'app-not-authorized') {
            print('❌ App not authorized - check SHA-1 fingerprint in Firebase Console');
          } else {
            print('❌ Other error: ${exception.message}');
          }
        },
        codeSent: (verificationId, resendToken) {
          print('✅ Code sent callback works');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print('✅ Auto retrieval timeout callback works');
        },
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      print('❌ Phone verification test failed: $e');
    }
    
    print('🔥 Firebase connection test completed!');
    
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    print('💡 Make sure you have:');
    print('   1. Added google-services.json to android/app/');
    print('   2. Added SHA-1 fingerprint to Firebase Console');
    print('   3. Enabled Phone Authentication in Firebase Console');
  }
}