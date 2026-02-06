/// App configuration settings
class AppConfig {
  /// Set to true to use Firebase Authentication
  /// Set to false to use Demo Authentication (no Firebase setup required)
  static const bool useFirebaseAuth = true;
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// App name
  static const String appName = 'Local Marketplace';
  
  /// Enable debug logging
  static const bool enableDebugLogging = true;
  
  /// Demo credentials for testing
  static const String demoPhoneNumber = '+91 9876543210';
  static const String demoOTP = '123456';
}