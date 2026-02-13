import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/network_service.dart';
import '../../widgets/shimmer_loading.dart';
import '../../models/product_model.dart';
import '../shops/shops_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NetworkService _networkService = NetworkService();
  bool _isOnline = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadProducts();
  }

  Future<void> _checkConnectivity() async {
    final isOnline = await _networkService.hasInternetConnection();
    setState(() {
      _isOnline = isOnline;
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOnline) {
      return _buildOfflineState();
    }

    return Scaffold(
      backgroundColor: AppTheme.softPink,
      appBar: AppBar(
        title: const Text('Local Marketplace'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Category Header
              _buildHeader(),

              const SizedBox(height: 16),

              // Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopsScreen())),
                      child: const Text('View Shops', style: TextStyle(color: AppTheme.primaryPink)),
                    ),
                  ],
                ),
              ),

              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return _buildShimmerGrid();
                  }

                  var products = productProvider.products;

                  if (products.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) => _buildProductCard(products[index]),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: AppTheme.primaryPink,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShopsScreen(searchQuery: query)));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search products or shops...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryPink),
                filled: true,
                fillColor: AppTheme.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Show product details or add to cart
          _showProductDetails(product);
        },
        borderRadius: BorderRadius.circular(16),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppTheme.darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.shopName,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                        InkWell(
                          onTap: () => _addToCart(product),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, size: 16, color: AppTheme.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(product.toProductModel());
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppTheme.primaryPink,
          onPressed: () {
            // Navigate to cart - will implement next
            DefaultTabController.of(context).animateTo(2); // Cart tab
          },
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Product Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightPink,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: product.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.shopping_bag, size: 80, color: AppTheme.primaryPink),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.store, size: 16, color: AppTheme.mediumGrey),
                        const SizedBox(width: 4),
                        Text(
                          product.shopName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _addToCart(product);
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPink,
                          foregroundColor: AppTheme.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.lightPink),
            const SizedBox(height: 16),
            const Text('No products available yet', style: TextStyle(color: AppTheme.darkGrey)),
            const SizedBox(height: 8),
            const Text('Check back soon for new items!', style: TextStyle(color: AppTheme.mediumGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductShimmer(),
    );
  }

  Widget _buildOfflineState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: AppTheme.lightPink),
            const SizedBox(height: 16),
            const Text('No Internet Connection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _checkConnectivity, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
