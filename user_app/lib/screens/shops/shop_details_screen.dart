import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/shop_model.dart';
import '../../models/product_model.dart';
import '../../providers/shop_provider.dart';
import '../../services/network_service.dart';
import '../orders/place_order_screen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailsScreen({super.key, required this.shop});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  List<Product> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    shopProvider.loadShopProducts(widget.shop.id);
  }

  void _toggleProductSelection(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  double get _totalAmount {
    return _selectedProducts.fold(0.0, (sum, product) => sum + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(widget.shop.name),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer2<ShopProvider, NetworkService>(
        builder: (context, shopProvider, networkService, child) {
          final products = shopProvider.getShopProducts(widget.shop.id);
          
          return Column(
            children: [
              // Shop Info Header
              Container(
                color: AppTheme.primaryPink,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.store,
                            size: 30,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.shop.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.shop.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.shop.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.shop.isOpen ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      widget.shop.isOpen ? 'Open' : 'Closed',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                  ],
                ),
              ),

              // Products List
              Expanded(
                child: shopProvider.isLoading && products.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      )
                    : shopProvider.error != null && products.isEmpty
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
                                    : 'Failed to load products',
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
                                  onPressed: _loadProducts,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPink,
                                    foregroundColor: AppTheme.white,
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : products.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 64,
                                      color: AppTheme.lightGrey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No products available',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.darkGrey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'This shop hasn\'t added any products yet',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.lightGrey,
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
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return _buildProductCard(product);
                                  },
                                ),
                              ),
              ),

              // Order Summary (if products selected)
              if (_selectedProducts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedProducts.length} items selected',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                          Text(
                            '₹${_totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryPink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.shop.isOpen && networkService.isOnline ? _placeOrder : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPink,
                            foregroundColor: AppTheme.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            !widget.shop.isOpen 
                              ? 'Shop Closed' 
                              : networkService.isOffline 
                                ? 'No Internet Connection'
                                : 'Place Order',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final isSelected = _selectedProducts.contains(product);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: product.isAvailable ? () => _toggleProductSelection(product) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppTheme.primaryPink, width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Product Image/Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 30,
                  color: AppTheme.primaryPink,
                ),
              ),
              const SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: product.isAvailable ? AppTheme.darkGrey : AppTheme.lightGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: product.isAvailable ? AppTheme.darkGrey : AppTheme.lightGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: product.isAvailable ? AppTheme.primaryPink : AppTheme.lightGrey,
                          ),
                        ),
                        const Spacer(),
                        if (!product.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (product.isAvailable && isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryPink,
                            size: 24,
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

  void _placeOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceOrderScreen(
          shop: widget.shop,
          selectedProducts: _selectedProducts,
        ),
      ),
    );
  }
}