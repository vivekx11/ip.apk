import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/order_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../products/add_product_screen.dart';
import '../orders/order_management_screen.dart';
import '../orders/qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user == null) {
        print('No user found');
        return;
      }

      print('Loading shop for owner: ${user['id']}');
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      await shopProvider.loadShopByOwnerId(user['id']);
      
      if (shopProvider.currentShop != null && mounted) {
        final shopId = shopProvider.currentShop!['_id'] ?? shopProvider.currentShop!['id'];
        print('Shop loaded: $shopId');
        
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        
        await Future.wait([
          orderProvider.loadShopOrders(shopId),
          productProvider.loadShopProducts(shopId),
        ]);
        
        print('Orders: ${orderProvider.orders.length}, Products: ${productProvider.products.length}');
      } else {
        print('No shop found for owner');
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppTheme.errorRed,
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
        title: const Text('Shop Dashboard'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
      ),
      body: Consumer3<ShopProvider, OrderProvider, ProductProvider>(
        builder: (context, shopProvider, orderProvider, productProvider, child) {
          // Show loading
          if (shopProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if shop loading failed
          if (shopProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppTheme.errorRed),
                  const SizedBox(height: 16),
                  const Text(
                    'Error Loading Shop',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      shopProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryIndigo,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show message if no shop registered
          if (shopProvider.currentShop == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store_outlined, size: 64, color: AppTheme.lightIndigo),
                  const SizedBox(height: 16),
                  const Text(
                    'No Shop Registered',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please register your shop first',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryIndigo,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final orders = orderProvider.orders;
          final products = productProvider.products;
          final pendingOrders = orders.where((o) => o.status == 'pending').length;
          final totalRevenue = orders
              .where((o) => o.status == 'completed')
              .fold(0.0, (sum, order) => sum + order.totalAmount);

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  _buildStatsGrid(orders, pendingOrders, totalRevenue, products),

                  const SizedBox(height: 24),

                  // My Products Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddProductScreen()),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryIndigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  productProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : products.isEmpty
                          ? _buildEmptyProducts()
                          : _buildProductsGrid(products, productProvider),

                  const SizedBox(height: 24),

                  // Sales Visualization
                  const Text(
                    'Recent Sales Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSalesChart(orders),

                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionsGrid(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(List<dynamic> orders, int pending, double revenue, List<Map<String, dynamic>> products) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Orders', '${orders.length}', Icons.receipt_long, AppTheme.successGreen)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Pending', '$pending', Icons.pending_actions, AppTheme.warningOrange)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Revenue', '₹${revenue.toStringAsFixed(0)}', Icons.payments, AppTheme.primaryIndigo)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Products', '${products.length}', Icons.inventory_2, AppTheme.primaryBlue)),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesChart(List<dynamic> orders) {
    return Container(
      height: 180,
      padding: const EdgeInsets.only(top: 24, right: 24, left: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: orders.isEmpty 
                ? [const FlSpot(0, 0)] 
                : orders.reversed.toList().asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.totalAmount)).toList(),
              isCurved: true,
              color: AppTheme.primaryIndigo,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryIndigo.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Add Product',
                Icons.add_shopping_cart,
                AppTheme.successGreen,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen())),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Verify QR',
                Icons.qr_code_scanner,
                AppTheme.warningOrange,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScannerScreen())),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Manage Orders',
          Icons.list_alt,
          AppTheme.primaryIndigo,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen())),
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap, {bool isFullWidth = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.lightIndigo),
          const SizedBox(height: 16),
          const Text(
            'No products yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first product to get started',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryIndigo,
              foregroundColor: AppTheme.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Map<String, dynamic>> products, ProductProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length > 4 ? 4 : products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final imageUrl = product['imageUrls'] != null && (product['imageUrls'] as List).isNotEmpty
            ? product['imageUrls'][0]
            : '';
        final isAvailable = product['isAvailable'] ?? true;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppTheme.lightGrey,
                                child: const Icon(Icons.image_not_supported, size: 40, color: AppTheme.mediumGrey),
                              ),
                            )
                          : Container(
                              color: AppTheme.lightGrey,
                              child: const Icon(Icons.shopping_bag, size: 40, color: AppTheme.primaryIndigo),
                            ),
                    ),
                    // Availability Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? AppTheme.successGreen : AppTheme.errorRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isAvailable ? 'Available' : 'Unavailable',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            product['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product['category'] ?? 'General',
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
                            '₹${(product['price'] ?? 0).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.primaryIndigo,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await provider.toggleAvailability(product['_id']);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isAvailable ? AppTheme.successGreen : AppTheme.mediumGrey,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                isAvailable ? Icons.visibility : Icons.visibility_off,
                                size: 16,
                                color: AppTheme.white,
                              ),
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
        );
      },
    );
  }
}
