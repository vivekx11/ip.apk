import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/order_service.dart';

class PlaceOrderScreen extends StatefulWidget {
  final String shopId;

  const PlaceOrderScreen({
    super.key,
    required this.shopId,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final OrderService _orderService = OrderService();
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final shopItems = cart.getShopItems(widget.shopId);
        final totalAmount = shopItems.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        final shopName = shopItems.isNotEmpty ? shopItems.first.shopName : 'Shop';

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
                                      shopName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Local Shop',
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

                      ...shopItems.map((item) => _buildOrderItem(item)),

                  const SizedBox(height: 24),

                  // Order Notes
                  const Text(
                    'Your Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'Enter your name',
                            prefixIcon: const Icon(Icons.person, color: AppTheme.primaryPink),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.primaryPink, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Special Instructions (Optional)',
                            hintText: 'Any special requests or notes...',
                            prefixIcon: const Icon(Icons.note, color: AppTheme.primaryPink),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.primaryPink, width: 2),
                            ),
                          ),
                        ),
                      ],
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
                          'Total (${shopItems.length} items)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}',
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
                        onPressed: _isPlacingOrder ? null : () => _placeOrder(cart, shopItems, totalAmount, shopName),
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
      },
    );
  }

  Widget _buildOrderItem(item) {
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
                    item.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${(item.price * item.quantity).toStringAsFixed(2)}',
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

  Future<void> _placeOrder(CartProvider cart, List shopItems, double totalAmount, String shopName) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Get user ID (use phone number if no user object)
      final userId = authProvider.currentUser?.id ?? 
                     authProvider.currentUser?.phoneNumber ?? 
                     'guest-${DateTime.now().millisecondsSinceEpoch}';
      
      // Prepare order items
      final items = shopItems.map((item) => {
        'productId': item.productId,
        'productName': item.productName,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
      }).toList();

      // Place order
      final response = await _orderService.placeOrder(
        userId: userId,
        shopId: widget.shopId,
        items: items,
        totalAmount: totalAmount,
        customerName: _nameController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (response['success'] == true) {
        final order = response['data'];
        final pickupCode = order['pickupCode'];
        
        // Clear cart
        cart.clearShopItems(widget.shopId);
        
        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successGreen, size: 32),
                  SizedBox(width: 12),
                  Text('Order Placed!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your pickup code is:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.softPink,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryPink, width: 2),
                    ),
                    child: Text(
                      pickupCode,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Show this code to the shop owner to collect your order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to cart
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }
}