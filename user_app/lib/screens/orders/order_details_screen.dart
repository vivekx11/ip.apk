import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../models/order_model.dart';
import '../../utils/date_utils.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            _buildStatusHeader(),

            // Order Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Info
                  _buildSectionTitle('Shop Details'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.store,
                    title: order.shopName,
                    subtitle: order.shopAddress,
                  ),

                  const SizedBox(height: 24),

                  // Order Info
                  _buildSectionTitle('Order Information'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Order Date', _formatDateTime(order.createdAt)),
                  if (order.acceptedAt != null)
                    _buildInfoRow('Accepted At', _formatDateTime(order.acceptedAt!)),
                  if (order.completedAt != null)
                    _buildInfoRow('Completed At', _formatDateTime(order.completedAt!)),
                  _buildInfoRow('Customer Name', order.customerName),
                  if (order.notes != null && order.notes!.isNotEmpty)
                    _buildInfoRow('Notes', order.notes!),

                  const SizedBox(height: 24),

                  // Pickup Code (if accepted)
                  if (order.status == OrderStatus.Accepted) ...[
                    _buildSectionTitle('Pickup Code'),
                    const SizedBox(height: 12),
                    _buildPickupCodeCard(),
                    const SizedBox(height: 24),
                  ],

                  // Order Items
                  _buildSectionTitle('Order Items'),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => _buildOrderItem(item)),

                  const SizedBox(height: 16),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.softPink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryPink.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primaryPink),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Payment will be collected at the shop when you pick up your order.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    Color bgColor;
    Color textColor;
    String title;
    String subtitle;
    IconData icon;

    switch (order.status) {
      case OrderStatus.Pending:
        bgColor = AppTheme.warningYellow;
        textColor = AppTheme.white;
        title = '⏳ Order Placed';
        subtitle = 'Waiting for shop owner to accept your order';
        icon = Icons.access_time;
        break;
      case OrderStatus.Accepted:
        bgColor = AppTheme.successGreen;
        textColor = AppTheme.white;
        title = '✅ Order Accepted';
        subtitle = 'Your order has been accepted by the shop owner';
        icon = Icons.check_circle;
        break;
      case OrderStatus.Completed:
        bgColor = AppTheme.primaryPink;
        textColor = AppTheme.white;
        title = '🎉 Order Completed';
        subtitle = 'Thank you for your order!';
        icon = Icons.done_all;
        break;
      case OrderStatus.Cancelled:
        bgColor = AppTheme.errorRed;
        textColor = AppTheme.white;
        title = '❌ Order Rejected';
        subtitle = 'Your order was rejected by the shop owner';
        icon = Icons.cancel;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: textColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.darkGrey,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softPink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryPink, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCodeCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryPink, AppTheme.primaryPink.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'Show this code at the shop',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.pickupPin,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPink,
                  letterSpacing: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: order.pickupPin));
                // Show snackbar would need context, so we'll skip it here
              },
              icon: const Icon(Icons.copy, color: AppTheme.white, size: 18),
              label: const Text(
                'Copy Code',
                style: TextStyle(color: AppTheme.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.productImage != null && item.productImage!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.shopping_bag,
                            size: 30,
                            color: AppTheme.primaryPink,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.shopping_bag,
                      size: 30,
                      color: AppTheme.primaryPink,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.price.toStringAsFixed(2)} × ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return DateTimeUtils.formatToIST12Hour(date);
  }
}
