import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class PickupCodeVerificationScreen extends StatefulWidget {
  final String? prefilledCode;

  const PickupCodeVerificationScreen({super.key, this.prefilledCode});

  @override
  State<PickupCodeVerificationScreen> createState() => _PickupCodeVerificationScreenState();
}

class _PickupCodeVerificationScreenState extends State<PickupCodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isVerifying = false;
  OrderModel? _verifiedOrder;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledCode != null) {
      _codeController.text = widget.prefilledCode!;
      _verifyCode();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Verify Pickup Code'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryIndigo,
                      AppTheme.primaryIndigo.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: AppTheme.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Customer Pickup Verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit pickup code shown by the customer to verify their order.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Code Input Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Pickup Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Code Input Field
                    TextField(
                      controller: _codeController,
                      focusNode: _codeFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                        color: AppTheme.primaryIndigo,
                      ),
                      decoration: InputDecoration(
                        hintText: '000000',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: AppTheme.lightGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.lightGrey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          _errorMessage = null;
                          _verifiedOrder = null;
                        });
                        
                        if (value.length == 6) {
                          _verifyCode();
                        }
                      },
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _codeController.text.length == 6 && !_isVerifying
                            ? _verifyCode
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryIndigo,
                          foregroundColor: AppTheme.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isVerifying
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Verifying...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Verify Code',
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
            ),

            // Order Details (if verified)
            if (_verifiedOrder != null) ...[
              const SizedBox(height: 24),
              _buildOrderDetails(_verifiedOrder!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successGreen, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Order Verified Successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Information
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 12),

            _buildDetailRow('Order ID', '#${order.id}'),
            _buildDetailRow('Customer', 'Customer ${order.userId}'),
            _buildDetailRow('Total Amount', '₹${order.totalAmount.toStringAsFixed(2)}'),
            _buildDetailRow('Order Time', _formatDateTime(order.createdAt)),
            _buildDetailRow('Status', order.statusDisplayName),

            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Customer Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.notes!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _codeController.clear();
                        _verifiedOrder = null;
                        _errorMessage = null;
                      });
                      _codeFocusNode.requestFocus();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryIndigo,
                      side: const BorderSide(color: AppTheme.primaryIndigo),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Verify Another'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _completeOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Complete Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
      _verifiedOrder = null;
    });

    try {
      // Use the order provider to verify pickup code
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final verifiedOrder = await orderProvider.verifyPickupCode(code);

      setState(() {
        _verifiedOrder = verifiedOrder;
      });

      if (verifiedOrder != null) {
        // Haptic feedback for success
        HapticFeedback.lightImpact();
      } else {
        setState(() {
          _errorMessage = 'Invalid pickup code. Please check and try again.';
        });

        // Haptic feedback for error
        HapticFeedback.vibrate();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _completeOrder(OrderModel order) async {
    try {
      // TODO: API call to mark order as completed
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order completed successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}