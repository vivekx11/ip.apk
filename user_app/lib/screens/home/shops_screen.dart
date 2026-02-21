import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/shop_model.dart';
import '../../services/notification_service.dart';
import '../../services/subscription_service.dart';
import '../shops/shop_details_screen.dart';
import 'notifications_screen.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<Shop> _shops = [];
  List<Shop> _filteredShops = [];
  List<String> _subscribedShopIds = [];
  bool _isLoading = true;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadShops();
    _loadUnreadNotifications();
    _loadSubscriptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUnreadNotifications() async {
    final count = await _notificationService.getUnreadCount();
    if (mounted) {
      setState(() {
        _unreadNotifications = count;
      });
    }
  }

  Future<void> _loadSubscriptions() async {
    final subscribed = await _subscriptionService.getSubscribedShops();
    if (mounted) {
      setState(() {
        _subscribedShopIds = subscribed;
      });
    }
  }

  void _loadShops() {
    // TODO: Replace with actual API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _shops = [
          Shop(
            id: '1',
            name: 'Fresh Mart',
            description: 'Fresh groceries and vegetables',
            category: 'Grocery',
            rating: 4.5,
            address: '123 Main Street',
            phone: '+1234567890',
            isOpen: true,
            imageUrl: '',
          ),
          Shop(
            id: '2',
            name: 'Tech Hub',
            description: 'Latest electronics and gadgets',
            category: 'Electronics',
            rating: 4.7,
            address: '456 Tech Avenue',
            phone: '+1234567891',
            isOpen: true,
            imageUrl: '',
          ),
          Shop(
            id: '3',
            name: 'Cozy Cafe',
            description: 'Coffee, snacks and light meals',
            category: 'Food',
            rating: 4.3,
            address: '789 Coffee Lane',
            phone: '+1234567892',
            isOpen: false,
            imageUrl: '',
          ),
          Shop(
            id: '4',
            name: 'Fashion Store',
            description: 'Trendy clothes and accessories',
            category: 'Fashion',
            rating: 4.2,
            address: '321 Style Street',
            phone: '+1234567893',
            isOpen: true,
            imageUrl: '',
          ),
        ];
        _filteredShops = _shops;
        _isLoading = false;
      });
    });
  }

  void _filterShops(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredShops = _shops;
      } else {
        _filteredShops = _shops.where((shop) {
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
        actions: [
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
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppTheme.primaryPink,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterShops,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryPink,
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
                              'Try adjusting your search',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredShops.length,
                        itemBuilder: (context, index) {
                          final shop = _filteredShops[index];
                          return _buildShopCard(shop);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Shop shop) {
    final isSubscribed = _subscribedShopIds.contains(shop.id);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopDetailsScreen(shop: shop),
            ),
          );
          // Refresh subscriptions after returning
          _loadSubscriptions();
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
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.store,
                        size: 40,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                    if (isSubscribed)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.successGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            size: 16,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                  ],
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
                        const SizedBox(width: 8),
                        if (isSubscribed)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  size: 12,
                                  color: AppTheme.successGreen,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Subscribed',
                                  style: TextStyle(
                                    color: AppTheme.successGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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