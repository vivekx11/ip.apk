import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/order_provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Order QR'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isScanned) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() {
                    _isScanned = true;
                  });
                  _processOrder(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          // Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Align QR code within the frame',
                  style: TextStyle(color: AppTheme.white),
                ),
              ),
            ),
          ),
          if (_isScanned)
            const Center(
              child: CircularProgressIndicator(color: AppTheme.white),
            ),
        ],
      ),
    );
  }

  Future<void> _processOrder(String orderId) async {
    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      // Load order details
      final order = await orderProvider.fetchOrderById(orderId);
      
      if (mounted) {
        if (order != null) {
          _showOrderConfirmation(order);
        } else {
          _showError('Order not found!');
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('Error processing QR code: $e');
      }
    }
  }

  void _showOrderConfirmation(dynamic order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Found!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryIndigo,
              ),
            ),
            const SizedBox(height: 16),
            Text('Order ID: ${order.id}'),
            Text('Customer: ${order.userName}'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _isScanned = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Mark order as completed
                      await Provider.of<OrderProvider>(context, listen: false)
                          .updateOrderStatus(order.id, 'completed');
                      if (mounted) {
                        Navigator.pop(context); // Close sheet
                        Navigator.pop(context); // Close scanner
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order marked as completed!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                    ),
                    child: const Text('Confirm Pickup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorRed),
    );
    setState(() {
      _isScanned = false;
    });
  }
}
