import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'services/network_service.dart';
import 'widgets/offline_banner.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize network service
  final networkService = NetworkService();
  await networkService.initialize();
  
  runApp(MyApp(networkService: networkService));
}

class MyApp extends StatelessWidget {
  final NetworkService networkService;
  
  const MyApp({super.key, required this.networkService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: networkService),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Local Marketplace - Shop Owner',
        theme: AppTheme.shopOwnerAppTheme,
        home: const OfflineBanner(child: SplashScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}