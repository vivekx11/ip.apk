import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/user_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/auth_provider.dart';
import 'services/network_service.dart';
import 'widgets/offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Local Marketplace - Customer',
        theme: AppTheme.userAppTheme,
        home: const OfflineBanner(child: SplashScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}