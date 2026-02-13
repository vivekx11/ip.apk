import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/shop_provider.dart';
import '../../providers/product_provider.dart';
import '../products/add_product_screen.dart';
import '../products/product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      if (shopProvider.currentShop != null) {
        final shopId = shopProvider.currentShop!['_id'] ?? shopProvider.currentShop!['id'];
        await Provider.of<ProductProvider>(context, listen: false)
            .loadShopProducts(shopId);
      }
    } catch (e) {
      print('Error loading products: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              ).then((_) => _loadProducts());
            },
          ),
        ],
      ),
      body: Consumer2<ShopProvider, ProductProvider>(
        builder: (context, shopProvider, productProvider, child) {
          if (shopProvider.currentShop == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 80,
                    color: AppTheme.lightIndigo,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Shop Registered',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please register your shop first',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.blueGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = productProvider.products;

          if (products.isEmpty) {
            return const Center(
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
            );
          }

          return RefreshIndicator(
            onRefresh: _loadProducts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final imageUrls = product['imageUrls'];
                final hasImage = imageUrls != null && imageUrls is List && imageUrls.isNotEmpty;
                final stock = product['stock'] ?? 0;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      ).then((_) => _loadProducts());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Product Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: hasImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrls[0],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.shopping_bag,
                                          size: 30,
                                          color: AppTheme.primaryIndigo,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.shopping_bag,
                                    size: 30,
                                    color: AppTheme.primaryIndigo,
                                  ),
                          ),
                          const SizedBox(width: 12),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['description'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.blueGrey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      '₹${(product['price'] ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryIndigo,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: stock > 0 
                                            ? AppTheme.successGreen.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        stock > 0 ? 'Stock: $stock' : 'Out of stock',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: stock > 0 
                                              ? AppTheme.successGreen
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (product['isAvailable'] ?? false)
                                            ? AppTheme.successGreen.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        (product['isAvailable'] ?? false) ? 'Available' : 'Unavailable',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: (product['isAvailable'] ?? false)
                                              ? AppTheme.successGreen
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Arrow Icon
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppTheme.mediumGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          ).then((_) => _loadProducts());
        },
        backgroundColor: AppTheme.primaryIndigo,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }
}