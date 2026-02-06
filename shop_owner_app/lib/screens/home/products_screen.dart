import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add product
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_outlined,
              size: 80,
              color: AppTheme.lightIndigo,
            ),
            SizedBox(height: 16),
            Text(
              'No products yet',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first product to get started',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.blueGrey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add product
        },
        backgroundColor: AppTheme.primaryIndigo,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }
}