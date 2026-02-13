import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../orders/place_order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppTheme.lightPink,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some products to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final item = cart.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
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
                              child: item.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl,
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

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.shopName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.darkGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryPink,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Controls
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: AppTheme.primaryPink,
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          cart.updateQuantity(
                                            item.productId,
                                            item.quantity - 1,
                                          );
                                        } else {
                                          cart.removeItem(item.productId);
                                        }
                                      },
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: AppTheme.primaryPink,
                                      onPressed: () {
                                        cart.updateQuantity(
                                          item.productId,
                                          item.quantity + 1,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.removeItem(item.productId);
                                  },
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Total and Checkout
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
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        Text(
                          '₹${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
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
                        onPressed: () {
                          // Get the first shop ID from cart items
                          final shopId = cart.cartItems.first.shopId;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceOrderScreen(shopId: shopId),
                            ),
                          );
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
                          'Proceed to Checkout',
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
          );
        },
      ),
    );
  }
}