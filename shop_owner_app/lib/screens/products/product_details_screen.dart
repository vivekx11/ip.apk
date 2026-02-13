import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import 'edit_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrls = product['imageUrls'];
    final hasImage = imageUrls != null && imageUrls is List && imageUrls.isNotEmpty;
    final imageUrl = hasImage ? imageUrls[0] : '';
    final isAvailable = product['isAvailable'] ?? true;
    final stock = product['stock'] ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: AppTheme.white,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.lightGrey,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    )
                  : Container(
                      color: AppTheme.lightGrey,
                      child: const Icon(
                        Icons.shopping_bag,
                        size: 80,
                        color: AppTheme.primaryIndigo,
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Availability
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                      ),
                      Switch(
                        value: isAvailable,
                        onChanged: (value) => _toggleAvailability(context),
                        activeColor: AppTheme.successGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAvailable ? 'Available' : 'Unavailable',
                    style: TextStyle(
                      fontSize: 16,
                      color: isAvailable ? AppTheme.successGreen : AppTheme.errorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.currency_rupee, color: AppTheme.primaryIndigo, size: 32),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.mediumGrey,
                                ),
                              ),
                              Text(
                                '₹${(product['price'] ?? 0).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryIndigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stock & Category
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.inventory_2, color: AppTheme.primaryIndigo, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Stock',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.mediumGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stock > 0 ? '$stock units' : 'Out of stock',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: stock > 0 ? AppTheme.darkGrey : AppTheme.errorRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.category, color: AppTheme.primaryIndigo, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Category',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.mediumGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product['category'] ?? 'General',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.description, color: AppTheme.primaryIndigo, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product['description'] ?? 'No description available',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.darkGrey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _toggleAvailability(context),
                          icon: Icon(isAvailable ? Icons.visibility_off : Icons.visibility),
                          label: Text(isAvailable ? 'Mark Unavailable' : 'Mark Available'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryIndigo,
                            side: const BorderSide(color: AppTheme.primaryIndigo),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(product: product),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryIndigo,
                            foregroundColor: AppTheme.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleAvailability(BuildContext context) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final productId = product['_id'] ?? product['id'];
    
    final success = await productProvider.toggleAvailability(productId);
    
    if (context.mounted) {
      if (success) {
        Navigator.pop(context); // Go back to refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product availability updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update availability')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final productId = product['_id'] ?? product['id'];
      
      final success = await productProvider.deleteProduct(productId);
      
      if (context.mounted) {
        if (success) {
          Navigator.pop(context); // Go back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete product')),
          );
        }
      }
    }
  }
}
