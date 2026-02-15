import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../services/network_service.dart';
import '../../services/simple_auth_service.dart';
import 'pickup_code_verification_screen.dart';

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
          backgroundColor: AppTheme.lightGrey,
          appBar: AppBar(
            title: const Text('Order Management'),
            backgroundColor: AppTheme.primaryIndigo,
            foregroundColor: AppTheme.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.white,
              labelColor: AppTheme.white,
              unselectedLabelColor: AppTheme.white.withOpacity(0.7),
              tabs: [
                Tab(
                  text: 'Pending (${orderProvider.pendingOrders.length})',
                  icon: const Icon(Icons.pending_actions, size: 20),
                ),
                Tab(
                  text: 'Accepted (${orderProvider.acceptedOrders.length})',
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                ),
                Tab(
                  text: 'Completed (${orderProvider.completedOrders.length})',
                  icon: const Icon(Icons.done_all, size: 20),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.statusDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Pickup Code (Prominent Display)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryIndigo,
                    AppTheme.primaryIndigo.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pickup Code',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.orderToken,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Details
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 18, color: AppTheme.darkGrey),
                const SizedBox(width: 4),
                Text(
                  '₹${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: AppTheme.blueGrey),
                const SizedBox(width: 4),
                Text(
                  _formatTime(order.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.blueGrey,
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
                  color: AppTheme.lightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Notes:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.notes!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(order, status),
          ],
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