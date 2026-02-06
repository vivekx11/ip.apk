import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/shop_model.dart';
import '../../providers/shop_provider.dart';
import '../../services/network_service.dart';
import 'shop_details_screen.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadShops() {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.loadShops();
  }

  void _filterShops(String query, List<Shop> shops) {
    setState(() {
      if (query.isEmpty) {
        _filteredShops = shops;
      } else {
        _filteredShops = shops.where((shop) {
          return shop.name.toLowerCase().contains(query.toLowerCase()) ||
                 shop.category.toLowerCase().contains(query.toLowerCase()) ||
                 shop.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Discover Shops'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer2<ShopProvider, NetworkService>(
        builder: (context, shopProvider, networkService, child) {
          // Update filtered shops when shops change
          if (_filteredShops.isEmpty && shopProvider.shops.isNotEmpty) {
            _filteredShops = shopProvider.shops;
          }

          return Column(
            children: [
              // Search Bar
              Container(
                color: AppTheme.primaryPink,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _filterShops(query, shopProvider.shops),
                  decoration: InputDecoration(
                    hintText: 'Search shops, categories...',
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
                child: shopProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      )
                    : shopProvider.error != null
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
                                    : shopProvider.error ?? 'Something went wrong',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.lightGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadShops,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPink,
                                    foregroundColor: AppTheme.white,
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
                                        color: AppTheme.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async => _loadShops(),
                                color: AppTheme.primaryPink,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _filteredShops.length,
                                  itemBuilder: (context, index) {
                                    final shop = _filteredShops[index];
                                    return _buildShopCard(shop);
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

  Widget _buildShopCard(Shop shop) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopDetailsScreen(shop: shop),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Shop Image/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shop.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: shop.isOpen ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            shop.isOpen ? 'Open' : 'Closed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            shop.category,
                            style: const TextStyle(
                              color: AppTheme.primaryPink,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          shop.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkGrey,
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
      ),
    );
  }
}