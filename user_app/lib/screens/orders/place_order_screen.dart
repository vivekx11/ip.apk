import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import '../../models/shop_model.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import 'order_confirmation_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Shop shop;
  final List<Product> selectedProducts;

  const PlaceOrderScreen({
    super.key,
    required this.shop,
    required this.selectedProducts,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _totalAmount {
    return widget.selectedProducts.fold(0.0, (sum, product) => sum + product.price);
  }

  String _generatePickupCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Place Order'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Info
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.store,
                              size: 25,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.shop.address,
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Items
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...widget.selectedProducts.map((product) => _buildOrderItem(product)),

                  const SizedBox(height: 24),

                  // Order Notes
                  const Text(
                    'Special Instructions (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any special requests or notes for the shop owner...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryPink),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Info
                  Card(
                    elevation: 2,
                    color: AppTheme.primaryPink.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryPink,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment at Pickup',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryPink,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You will pay when you visit the shop to collect your order.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Order Summary & Place Order Button
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
                      'Total (${widget.selectedProducts.length} items)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    Text(
                      '₹${_totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
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
                    onPressed: _isPlacingOrder ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isPlacingOrder
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Place Order',
                            style: TextStyle(
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
      ),
    );
  }

  Widget _buildOrderItem(Product product) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.shopping_bag,
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
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              '₹${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Generate pickup code
    final pickupCode = _generatePickupCode();

    // Create order
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: Get from auth
      shopId: widget.shop.id,
      shopName: widget.shop.name,
      shopAddress: widget.shop.address,
      products: widget.selectedProducts,
      totalAmount: _totalAmount,
      pickupCode: pickupCode,
      status: OrderStatus.placed,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    setState(() {
      _isPlacingOrder = false;
    });

    // Navigate to confirmation screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(order: order),
        ),
      );
    }
  }
}