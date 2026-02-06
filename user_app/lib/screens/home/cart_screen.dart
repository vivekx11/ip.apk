import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppTheme.lightPink,
            ),
            SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add some products to get started',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}