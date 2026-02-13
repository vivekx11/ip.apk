import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';

class ShopProductsScreen extends StatelessWidget {
  final String shopName;

  const ShopProductsScreen({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softPink,
      appBar: AppBar(
        title: Text(shopName),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products
              .where((p) => p.shopName == shopName)
              .toList();

          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.lightPink),
                  SizedBox(height: 16),
                  Text('No products available', style: TextStyle(color: AppTheme.darkGrey)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppTheme.lightPink,
                                  child: const Icon(Icons.image_not_supported, size: 40, color: AppTheme.primaryPink),
                                ),
                              )
                            : Container(
                                color: AppTheme.lightPink,
                                child: const Icon(Icons.shopping_bag, size: 40, color: AppTheme.primaryPink),
                              ),
                      ),
                    ),
                    // Product Details
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.darkGrey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.primaryPink,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryPink,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: AppTheme.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
