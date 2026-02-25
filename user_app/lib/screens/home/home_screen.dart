import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/network_service.dart';
import '../../services/notification_service.dart';
import '../../services/location_service.dart';
import '../../widgets/shimmer_loading.dart';
import '../../models/product_model.dart';
import '../shops/shops_screen.dart';
import '../shops/shop_products_screen.dart';
import 'notifications_screen.dart';
import '../maps/nearby_shops_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NetworkService _networkService = NetworkService();
  final NotificationService _notificationService = NotificationService();
  bool _isOnline = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadProducts();
    _loadUnreadNotifications();
  }

  Future<void> _checkConnectivity() async {
    final isOnline = await _networkService.hasInternetConnection();
    setState(() {
      _isOnline = isOnline;
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    
    // Try to load nearby products based on user location
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('userLatitude');
      final lng = prefs.getDouble('userLongitude');
      
      if (lat != null && lng != null) {
        // User has set location, fetch nearby shops first
        final locationService = LocationService();
        final nearbyShops = await locationService.getDeliverableShops(
          latitude: lat,
          longitude: lng,
        );
        
        // If we have nearby shops, we could filter products by those shops
        // For now, just load all products
        print('Found ${nearbyShops.length} nearby shops');
      }
    } catch (e) {
      print('Error loading nearby shops: $e');
    }
    
    // Load all products
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  Future<void> _loadUnreadNotifications() async {
    final count = await _notificationService.getUnreadCount();
    if (mounted) {
      setState(() {
        _unreadNotifications = count;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
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
      backgroundColor: AppTheme.paleYellow,
      appBar: AppBar(
        title: const Text('Local Marketplace', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          // Map Icon
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppTheme.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyShopsMapScreen(),
                ),
              );
            },
          ),
          // Notification Bell Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.white),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                  _loadUnreadNotifications();
                },
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
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

              // Products Section - Shop-wise Carousel
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return _buildShimmerGrid();
                  }

                  var products = productProvider.products;

                  // Apply search filter
                  if (_searchQuery.isNotEmpty) {
                    products = products.where((product) {
                      final productName = product.name.toLowerCase();
                      final shopName = product.shopName.toLowerCase();
                      final description = product.description.toLowerCase();
                      
                      return productName.contains(_searchQuery) ||
                             shopName.contains(_searchQuery) ||
                             description.contains(_searchQuery);
                    }).toList();
                  }

                  if (products.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Group products by shop
                  final Map<String, List<Product>> shopProducts = {};
                  for (var product in products) {
                    if (!shopProducts.containsKey(product.shopName)) {
                      shopProducts[product.shopName] = [];
                    }
                    shopProducts[product.shopName]!.add(product);
                  }

                  return Column(
                    children: shopProducts.entries.map((entry) {
                      return _buildShopSection(entry.key, entry.value);
                    }).toList(),
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
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.primaryYellow,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryYellow.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkYellow.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search products or shops...',
                  hintStyle: TextStyle(color: AppTheme.mediumGrey.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primaryYellow),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.primaryYellow),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                          color: AppTheme.lightYellow,
                          child: const Icon(Icons.image_not_supported, size: 40, color: AppTheme.primaryYellow),
                        ),
                      )
                    : Container(
                        color: AppTheme.lightYellow,
                        child: const Icon(Icons.shopping_bag, size: 40, color: AppTheme.primaryYellow),
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
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                        InkWell(
                          onTap: () => _addToCart(product),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryYellow,
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
    final error = cartProvider.addItem(product.toProductModel());
    
    if (error != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppTheme.primaryYellow,
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
                color: AppTheme.lightYellow,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: product.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.shopping_bag, size: 80, color: AppTheme.primaryYellow),
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
                        color: AppTheme.primaryYellow,
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
                          backgroundColor: AppTheme.primaryYellow,
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
            Icon(
              _searchQuery.isNotEmpty 
                  ? Icons.search_off 
                  : Icons.shopping_bag_outlined,
              size: 64,
              color: AppTheme.lightYellow,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No products found' 
                  : 'No products available yet',
              style: const TextStyle(color: AppTheme.darkGrey),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Try searching with different keywords' 
                  : 'Check back soon for new items!',
              style: const TextStyle(color: AppTheme.mediumGrey, fontSize: 12),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.white,
                ),
                child: const Text('Clear Search'),
              ),
            ],
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

  Widget _buildShopSection(String shopName, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppTheme.primaryYellow,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      Text(
                        '${products.length} products',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopProductsScreen(shopName: shopName),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: AppTheme.primaryYellow),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 160,
                  child: _buildProductCard(products[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildOfflineState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: AppTheme.lightYellow),
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
