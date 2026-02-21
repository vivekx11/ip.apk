import 'package:flutter/material.dart';
import '../orders/order_history_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply wrap the OrderHistoryScreen without AppBar since MainScreen handles navigation
    return const OrderHistoryScreen();
  }
}