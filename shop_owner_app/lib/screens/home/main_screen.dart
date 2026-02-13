import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/shop_provider.dart';
import 'dashboard_screen.dart';
import 'products_screen.dart';
import '../orders/order_management_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProductsScreen(),
    const OrderManagementScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadShopData();
  }

  Future<void> _loadShopData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    
    final ownerId = userProvider.currentOwner?.id;
    if (ownerId != null && ownerId.isNotEmpty) {
      try {
        await shopProvider.loadShopByOwnerId(ownerId);
        print('✅ Shop loaded: ${shopProvider.currentShop?['name']}');
      } catch (e) {
        print('⚠️ Could not load shop: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryIndigo,
        unselectedItemColor: AppTheme.blueGrey,
        backgroundColor: AppTheme.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            activeIcon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}