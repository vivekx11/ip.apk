import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../models/order_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Animation
            Lottie.network(
              'https://lottie.host/cbca94fa-7450-424a-81f1-e37769992d95/6pS8Qz7N3q.json',
              width: 150,
              height: 150,
              repeat: false,
            ),

            const SizedBox(height: 16),

            // Success Message
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'Your order has been placed. Use the QR code or pickup code below for verification.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Pickup & QR Code Card
            Card(
              elevation: 12,
              shadowColor: AppTheme.primaryPink.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.softPink, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan to Verify Pickup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                    const SizedBox(height: 20),
                    QrImageView(
                      data: order.id,
                      version: QrVersions.auto,
                      size: 200.0,
                      foregroundColor: AppTheme.darkGrey,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Manual Pickup Code',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.softPink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.pickupCode,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPink,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => _copyToClipboard(context),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Code'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryPink,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Shop Info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shop Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.store,
                            size: 20,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.shopName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.darkGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.shopAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Order Summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...order.products.map((product) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.darkGrey,
                              ),
                            ),
                          ),
                          Text(
                            '₹${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              elevation: 2,
              color: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Next Steps',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Visit the shop at the address shown above\n'
                      '2. Show your 6-digit pickup code to the shop owner\n'
                      '3. The shop owner will verify your order\n'
                      '4. Make payment and collect your items\n'
                      '5. Your pickup code expires in 24 hours',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryPink,
                      side: const BorderSide(color: AppTheme.primaryPink),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to orders screen
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: order.pickupCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pickup code copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}