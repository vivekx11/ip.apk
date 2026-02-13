import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../../services/image_upload_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();

  final ImageUploadService _uploadService = ImageUploadService();
  List<XFile> _selectedImages = [];
  bool _isUploading = false;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final XFile? image = await _uploadService.pickImageFromGallery();
      if (image != null) {
        setState(() {
          _selectedImages = [image]; // Only one image for now
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _uploadService.pickImageFromCamera();
      if (image != null) {
        setState(() {
          _selectedImages = [image]; // Only one image for now
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.clear();
      _uploadedImageUrl = null;
    });
  }

  Future<void> _uploadAndSaveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    
    // Get owner ID - CRITICAL for shop identification
    final ownerId = authProvider.user?['phoneNumber'] ?? 
                    authProvider.user?['id'] ?? 
                    userProvider.currentOwner?.id;
    
    if (ownerId == null || ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Owner ID not found. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final shopName = userProvider.username ?? 'My Shop';
    
    // Get shopId - MUST have this before uploading
    String? shopId = shopProvider.currentShop?['_id'] ?? shopProvider.currentShop?['id'];
    
    // If no shopId, try to load it
    if (shopId == null || shopId.isEmpty) {
      try {
        print('🔍 Loading shop for owner: $ownerId');
        await shopProvider.loadShopByOwnerId(ownerId);
        shopId = shopProvider.currentShop?['_id'] ?? shopProvider.currentShop?['id'];
      } catch (e) {
        print('⚠️ Could not load shop: $e');
      }
    }

    setState(() {
      _isUploading = true;
    });

    try {
      print('🚀 Starting product upload...');
      print('📋 Owner ID: $ownerId');
      print('🏪 Shop ID: $shopId');
      print('🏷️ Shop Name: $shopName');
      
      // Validate we have required data
      if (shopId == null || shopId.isEmpty) {
        throw Exception('Shop ID not found. Backend will auto-create shop using ownerId.');
      }
      
      final response = await _uploadService.uploadProduct(
        imageFile: _selectedImages[0],
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        shopId: shopId, // CRITICAL: Send shopId
        shopName: shopName,
        ownerId: ownerId, // CRITICAL: Send ownerId for auto-shop creation
        category: _categoryController.text.trim().isNotEmpty 
            ? _categoryController.text.trim() 
            : 'General',
        stock: int.parse(_stockController.text.trim()),
        unit: 'piece',
      );

      setState(() {
        _isUploading = false;
      });

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Product uploaded successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        throw Exception(response['message'] ?? 'Upload failed');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      print('❌ Upload error: $e');
      
      String errorMessage = 'Upload failed';
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Cannot connect to server. Check internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Server is slow or unavailable.';
      } else if (e.toString().contains('Shop ID not found')) {
        errorMessage = 'Shop not found. Please restart app and login again.';
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _uploadAndSaveProduct,
            child: Text(
              _isUploading ? 'Uploading...' : 'Save',
              style: TextStyle(
                color: _isUploading ? Colors.grey : AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Images Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Image picker buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImages,
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImageFromCamera,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Selected images grid
                      if (_selectedImages.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImages[0].path),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _removeImage(0),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Product Details Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'Enter product name',
                          prefixIcon: Icon(Icons.shopping_bag),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter product description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'e.g., Electronics, Food, etc.',
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                hintText: '0.00',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter valid price';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: TextFormField(
                              controller: _stockController,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                                hintText: '0',
                                prefixIcon: Icon(Icons.inventory),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter stock';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter valid stock';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}