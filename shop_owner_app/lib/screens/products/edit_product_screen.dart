import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _selectedCategory;
  bool _isUpdating = false;

  final List<String> _categories = [
    'General',
    'Grocery',
    'Electronics',
    'Fashion',
    'Food',
    'Pharmacy',
    'Books',
    'Sports',
    'Home & Kitchen',
    'Beauty',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _descriptionController = TextEditingController(text: widget.product['description']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _stockController = TextEditingController(text: (widget.product['stock'] ?? 0).toString());
    _selectedCategory = widget.product['category'] ?? 'General';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Preview
              Center(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: () {
                    final imageUrls = widget.product['imageUrls'];
                    final hasImage = imageUrls != null && imageUrls is List && imageUrls.isNotEmpty;
                    
                    if (hasImage) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrls[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                      );
                    }
                    return const Icon(
                      Icons.shopping_bag,
                      size: 60,
                      color: AppTheme.primaryIndigo,
                    );
                  }(),
                ),
              ),

              const SizedBox(height: 24),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: const Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price & Stock Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (₹)',
                        prefixIcon: const Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppTheme.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stock',
                        prefixIcon: const Icon(Icons.inventory_2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppTheme.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter stock';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUpdating ? null : _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryIndigo,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Update Product',
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
    );
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final productId = widget.product['_id'] ?? widget.product['id'];

      final updates = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'stock': int.parse(_stockController.text.trim()),
        'category': _selectedCategory,
      };

      final success = await productProvider.updateProduct(productId, updates);

      if (mounted) {
        if (success) {
          Navigator.pop(context); // Go back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product updated successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update product'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
