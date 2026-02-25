import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../services/network_service.dart';
import '../../services/simple_auth_service.dart';
import 'pickup_code_verification_screen.dart';
import 'order_details_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authService = SimpleAuthService();
    
    // Get shopId from auth service
    final shopId = authService.shopId;
    
    if (shopId == null || shopId.isEmpty) {
      print('❌ No shopId found. Please login again.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shop not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    print('📋 Loading orders for shop: $shopId');
    orderProvider.loadShopOrders(shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text('Order Management', style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: AppTheme.primaryIndigo,
            foregroundColor: AppTheme.white,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.white,
              indicatorWeight: 3,
              labelColor: AppTheme.white,
              unselectedLabelColor: AppTheme.white.withOpacity(0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: [
                Tab(
                  text: 'Pending (${orderProvider.pendingOrders.length})',
                  icon: const Icon(Icons.pending_actions_outlined, size: 20),
                ),
                Tab(
                  text: 'Accepted (${orderProvider.acceptedOrders.length})',
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                ),
                Tab(
                  text: 'Completed (${orderProvider.completedOrders.length})',
                  icon: const Icon(Icons.done_all_outlined, size: 20),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PickupCodeVerificationScreen(),
                      ),
                    );
                  },
                  tooltip: 'Verify Pickup Code',
                ),
              ),
            ],
          ),
          body: Consumer2<OrderProvider, NetworkService>(
            builder: (context, orderProvider, networkService, child) {
              if (orderProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryIndigo,
                  ),
                );
              }

              if (orderProvider.error != null) {
                return Center(
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
                          : 'Failed to load orders',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        networkService.isOffline 
                          ? 'Please check your connection and try again'
                          : orderProvider.error ?? 'Something went wrong',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadOrders,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryIndigo,
                          foregroundColor: AppTheme.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _loadOrders(),
                color: AppTheme.primaryIndigo,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrdersList(orderProvider.pendingOrders, 'pending'),
                    _buildOrdersList(orderProvider.acceptedOrders, 'accepted'),
                    _buildOrdersList(orderProvider.completedOrders, 'completed'),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: AppTheme.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(status),
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Orders will appear here when customers place them',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, status);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Customer Name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryIndigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_outline, size: 16, color: AppTheme.primaryIndigo),
                ),
                const SizedBox(width: 10),
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Items Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryIndigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, size: 14, color: AppTheme.primaryIndigo),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        if (item.productImage != null && item.productImage!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.productImage!,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image_not_supported_outlined, size: 24, color: Color(0xFF9CA3AF)),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, size: 24, color: Color(0xFF9CA3AF)),
                          ),
                        const SizedBox(width: 12),
                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '₹${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const Text(
                                    ' × ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Item Total
                        Text(
                          '₹${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryIndigo,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const Divider(height: 20, thickness: 1),
                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        '₹${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryIndigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Time
            Row(
              children: [
                const Icon(Icons.access_time_outlined, size: 16, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 6),
                Text(
                  _formatTime(order.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),

            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.note_outlined, size: 14, color: Color(0xFFD97706)),
                        SizedBox(width: 6),
                        Text(
                          'Customer Notes:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.notes!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF92400E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // View Details Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryIndigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap to view full details',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryIndigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.primaryIndigo),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(order, status),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildActionButtons(OrderModel order, String status) {
    switch (status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectOrder(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Reject'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptOrder(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: AppTheme.white,
                ),
                child: const Text('Accept'),
              ),
            ),
          ],
        );

      case 'accepted':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _markReady(order),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Complete Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: AppTheme.white,
                ),
              ),
            ),
          ],
        );

      default:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppTheme.successGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Order Completed',
                style: TextStyle(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _acceptOrder(OrderModel order) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final networkService = Provider.of<NetworkService>(context, listen: false);
    
    if (networkService.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await orderProvider.updateOrderStatus(order.id, 'Accepted');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.id} accepted'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _rejectOrder(OrderModel order) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final networkService = Provider.of<NetworkService>(context, listen: false);
    
    if (networkService.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await orderProvider.updateOrderStatus(order.id, 'Cancelled');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.id} cancelled'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _markReady(OrderModel order) async {
    // This button will now complete the order directly
    // Show dialog to enter PIN
    final pinController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ask customer for their 4-digit PIN:'),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: 'Enter PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Verify & Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true && pinController.text.length == 4) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final networkService = Provider.of<NetworkService>(context, listen: false);
      
      if (networkService.isOffline) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Please check your network.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await orderProvider.verifyPinAndComplete(order.id, pinController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order #${order.id} completed successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppTheme.warningOrange;
      case 'accepted':
        return AppTheme.primaryIndigo;
      case 'completed':
        return AppTheme.successGreen;
      default:
        return AppTheme.blueGrey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.list_alt;
    }
  }

  String _getEmptyMessage(String status) {
    switch (status) {
      case 'pending':
        return 'No pending orders';
      case 'accepted':
        return 'No accepted orders';
      case 'completed':
        return 'No completed orders';
      default:
        return 'No orders found';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}