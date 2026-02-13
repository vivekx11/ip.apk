import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/product_api_service.dart';

/// Example screen showing how to fetch and display products
class ProductsListExample extends StatefulWidget {
  const ProductsListExample({Key? key}) : super(key: key);

  @override
  State<ProductsListExample> createState() => _ProductsListExampleState();
}

class _ProductsListExampleState extends State<ProductsListExample> {
  final _productService = ProductApiService();
  
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _productService.getProducts(
        isAvailable: true,
        limit: 50,
      );
      
      setState(() {
        _products = result['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products available'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final imageUrl = product['imageUrl'] ?? product['imageUrls']?[0] ?? '';
    final name = product['name'] ?? 'Unknown';
    final description = product['description'] ?? '';
    final price = product['price'] ?? 0.0;
    final shopName = product['shopName'] ?? 'Unknown Shop';
    final category = product['category'] ?? 'General';
    final stock = product['stock'] ?? 0;
    final unit = product['unit'] ?? 'piece';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          // Navigate to product details
          _showProductDetails(product);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
              ),
              const SizedBox(width: 12),
              
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.store, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          shopName,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(fontSize: 10, color: Colors.blue[700]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stock: $stock $unit',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(dynamic product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final imageUrl = product['imageUrl'] ?? product['imageUrls']?[0] ?? '';
          
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                // Image
                if (imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Name
                Text(
                  product['name'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                // Price
                Text(
                  '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  product['description'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                
                // Shop info
                ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(product['shopName'] ?? 'Unknown Shop'),
                  subtitle: Text('Category: ${product['category'] ?? 'General'}'),
                ),
                
                // Stock info
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: Text('Stock: ${product['stock'] ?? 0} ${product['unit'] ?? 'piece'}'),
                ),
                
                const SizedBox(height: 16),
                
                // Add to cart button (implement your cart logic)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
