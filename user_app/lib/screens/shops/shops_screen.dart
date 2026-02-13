import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../services/network_service.dart';
import 'shop_products_screen.dart';

class ShopsScreen extends StatefulWidget {
  final String? searchQuery;
  
  const ShopsScreen({super.key, this.searchQuery});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _searchController.text = widget.searchQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.loadProducts();
  }

  void _filterShops(String query, List<String> shops) {
    setState(() {
      if (query.isEmpty) {
        _filteredShops = shops;
      } else {
        _filteredShops = shops.where((shop) {
          return shop.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softPink,
      appBar: AppBar(
        title: const Text('Discover Shops'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.darkGrey,
        elevation: 0,
      ),
      body: Consumer2<ProductProvider, NetworkService>(
        builder: (context, productProvider, networkService, child) {
          // Get unique shop names from products
          final shopNames = productProvider.getUniqueShopNames();
          
          // Update filtered shops when shops change
          if (_filteredShops.isEmpty && shopNames.isNotEmpty) {
            _filteredShops = shopNames;
          }

          return Column(
            children: [
              // Search Bar
              Container(
                color: AppTheme.primaryPink,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _filterShops(query, shopNames),
                  decoration: InputDecoration(
                    hintText: 'Search shops...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryPink),
                    filled: true,
                    fillColor: AppTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              // Shops List
              Expanded(
                child: productProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      )
                    : productProvider.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  networkService.isOffline 
                                    ? Icons.wifi_off 
                                    : Icons.error_outline,
                                  size: 64,
                                  color: AppTheme.lightGrey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  networkService.isOffline 
                                    ? 'No internet connection'
                                    : 'Failed to load shops',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  networkService.isOffline 
                                    ? 'Please check your connection and try again'
                                    : productProvider.error ?? 'Something went wrong',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.lightGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadProducts,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPink,
                                    foregroundColor: AppTheme.darkGrey,
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : _filteredShops.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.store_outlined,
                                      size: 64,
                                      color: AppTheme.lightGrey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No shops found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.darkGrey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search or check back later',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.mediumGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async => _loadProducts(),
                                color: AppTheme.primaryPink,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _filteredShops.length,
                                  itemBuilder: (context, index) {
                                    final shopName = _filteredShops[index];
                                    final shopProducts = productProvider.products
                                        .where((p) => p.shopName == shopName)
                                        .toList();
                                    return _buildShopCard(shopName, shopProducts.length);
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShopCard(String shopName, int productCount) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopProductsScreen(shopName: shopName),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Shop Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.lightPink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store,
                  size: 40,
                  color: AppTheme.primaryPink,
                ),
              ),
              const SizedBox(width: 16),

              // Shop Details
              Expanded(
                child: Column(
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag, size: 16, color: AppTheme.mediumGrey),
                        const SizedBox(width: 4),
                        Text(
                          '$productCount products',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.mediumGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}